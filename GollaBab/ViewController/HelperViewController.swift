//
//  HelperViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HelperViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "도움말"
    }
    
    private func setupUI() {
        tableView.backgroundColor = .bgColor
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "HelperCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HelperCell")
        HelperViewModel.shared.loadHelperList()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfHelper> { dataSource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "HelperCell") as! HelperCell
            cell.lblTitle.text = item.title()
            cell.lblDescription.text = item.description()
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            let header = ds.sectionModels[index].header
            
            return header
        }
        
        HelperViewModel.shared.helperItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
