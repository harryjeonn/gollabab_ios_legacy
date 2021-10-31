//
//  MoreViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MoreViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "더보기"
    }
    
    private func setupUI() {
        tableView.backgroundColor = .bgColor
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "moreCell")
        MoreViewModel.shared.loadMoreList()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfMore> { dataSource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "moreCell") as! MoreCell
            cell.lblTitle.text = item.title()
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            let header = ds.sectionModels[index].header
            
            return header
        }
        
        MoreViewModel.shared.moreItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(MoreType.self)
            .subscribe(onNext: { item in
                self.setupCellEvent(item)
            }).disposed(by: disposeBag)
    }
    
    private func setupCellEvent(_ type: MoreType) {
        var vc: UIViewController?
        switch type {
        case .searchRange:
            guard let searchRangeVC = self.storyboard?.instantiateViewController(withIdentifier: "SetSearchRangeViewController") as? SetSearchRangeViewController else { return }
            vc = searchRangeVC
        case .inAppPayment:
            guard let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else { return }
            vc = paymentVC
        case .openSource:
            guard let openSourceVC = self.storyboard?.instantiateViewController(withIdentifier: "OpenSourceViewController") as? OpenSourceViewController else { return }
            vc = openSourceVC
        case .appReview:
            // 앱 리뷰 링크로 이동
            print("tap appReview")
        case .helper:
            // 도움말 페이지로 이동
            print("tap helper")
        }
        guard let vc = vc else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
