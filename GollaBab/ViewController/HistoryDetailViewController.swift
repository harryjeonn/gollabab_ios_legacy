//
//  HistoryDetailViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/09/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HistoryDetailViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfHistoryDetailData>!
    
    private var items = [String]()
    var navTitle = ""
    var itemSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupTapEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = navTitle
    }
    
    private func setupUI() {
        btnRetry.backgroundColor = .themeColor
        btnRetry.layer.cornerRadius = 10
        btnRetry.setTitleColor(.whiteColor, for: .normal)
        btnRetry.setTitle("다시하기", for: .normal)
        
        tableView.backgroundColor = .bgColor
    }
    
    private func setupTableView() {
        HistoryDetailViewModel.shared.loadHistoryDetail()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let nib = UINib(nibName: "HistoryDetailCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryDetailCell")
        tableView.rowHeight = 40
        
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfHistoryDetailData> { dataSource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "HistoryDetailCell") as! HistoryDetailCell
            cell.backgroundColor = .bgColor
            cell.selectionStyle = .none
            cell.lblTitle.text = item
            cell.lblTitle.textColor = .themeColor
            if indexPath.section != 0 {
                self.items.append(item)
            }
            return cell
        }
        
        HistoryDetailViewModel.shared.historyDetailData
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTapEvent() {
        btnRetry.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "InsertViewController") as? InsertViewController else { return }
                vc.items = self.items
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        btnDelete.rx.tap
            .bind {
                let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: {(alert: UIAlertAction!) in
                    CoreDataManager.shared.deleteHistory(self.itemSection)
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }
}

extension HistoryDetailViewController: UIScrollViewDelegate, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderView()
        view.lblTitle.text = self.dataSource.sectionModels[section].header
        return view
    }
}
