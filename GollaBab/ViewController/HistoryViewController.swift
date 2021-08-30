//
//  HistoryViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HistoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let name = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "지난 결과"
    }
    
    private func setupUI() {
        tableView.backgroundColor = .bgColor
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryCell")
        tableView.rowHeight = 40
        
        let convertedData = HistoryViewModel.shared.convertHistory(CoreDataManager.shared.loadHistory())
        
        HistoryViewModel.shared.history.accept(convertedData)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfHistoryData> { dataSource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
            cell.backgroundColor = .bgColor
            cell.selectionStyle = .none
            cell.lblTitle.text = item.title
            cell.lblTitle.textColor = .themeColor
            cell.lblDate.text = item.date
            cell.lblDate.textColor = .lightGray
            
            return cell
        }
        
        HistoryViewModel.shared.history
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { index in
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailViewController") as? HistoryDetailViewController else { return }
                self.name.subscribe(onNext: { name in
                    vc.navTitle = name
                }).disposed(by: self.disposeBag)
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(HistoryItem.self)
            .subscribe(onNext: { history in
                self.name.onNext(history.title)
            }).disposed(by: disposeBag)
    }
}
