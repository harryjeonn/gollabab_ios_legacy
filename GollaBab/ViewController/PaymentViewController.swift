//
//  PaymentViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PaymentViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "인앱결제"
    }
    
    private func setupUI() {
        tableView.backgroundColor = .bgColor
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "PaymentCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PaymentCell")
        PaymentViewModel.shared.loadPaymentList()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfPayment> { dataSource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell
            cell.lblDescription.text = item.description()
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            let header = ds.sectionModels[index].header
            
            return header
        }
        
        PaymentViewModel.shared.paymentItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(PaymentType.self)
            .subscribe(onNext: { type in
                print(type)
            }).disposed(by: disposeBag)
    }
}
