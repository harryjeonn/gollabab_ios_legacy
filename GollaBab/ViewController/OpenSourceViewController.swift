//
//  OpenSourceViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class OpenSourceViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "오픈소스"
    }
    
    private func setupUI() {
        tableView.backgroundColor = .bgColor
        tableView.rowHeight = 40
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "OpenSourceCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OpenSourceCell")
        OpenSourceViewModel.shared.loadOpenSourceList()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfOpenSource> { dataSource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "OpenSourceCell") as! OpenSourceCell
            cell.lblTitle.text = item.title()
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            let header = ds.sectionModels[index].header
            
            return header
        }
        
        OpenSourceViewModel.shared.openSourceItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(OpenSourceType.self)
            .subscribe(onNext: { type in
                self.goToDetail(type)
            }).disposed(by: disposeBag)
    }
    
    private func goToDetail(_ type: OpenSourceType) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpenSourceDetailViewController") as? OpenSourceDetailViewController else { return }
        vc.text = type.license()
        vc.naviTitle = type.title()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
