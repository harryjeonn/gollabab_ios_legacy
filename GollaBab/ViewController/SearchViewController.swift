//
//  SearchViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: BaseViewController {
    @IBOutlet var textField: UITextField!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var clearView: UIView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var lblEmpty: UILabel!
    
    private var disposeBag = DisposeBag()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfSearchHistoryData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextField()
        setupTapEvent()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "검색"
        textField.text = nil
        SearchHistoryViewModel.shared.loadSearchHistory()
        checkEmpty()
    }
    
    private func setupUI() {
        btnSearch.backgroundColor = .themeColor
        btnSearch.setTitle("검색", for: .normal)
        btnSearch.setTitleColor(.whiteColor, for: .normal)
        btnSearch.layer.cornerRadius = 10
        
        textField.textColor = .themeColor
        textField.font = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
        textField.placeholder = "검색할 키워드를 입력해주세요."
        
        tableView.backgroundColor = .bgColor
        
        clearView.backgroundColor = .clear
        clearView.isHidden = true
        
        emptyView.backgroundColor = .bgColor
        
        lblEmpty.text = "최근 검색기록이 없습니다."
        lblEmpty.font = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
        lblEmpty.textColor = .themeColor
        
    }
    
    private func setupTextField() {
        textField.rx
            .controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .subscribe(onNext: { _ in
                print("hoxvi exit")
                self.clearView.isHidden = true
            }).disposed(by: disposeBag)
        
        textField.rx
            .controlEvent([.editingDidBegin])
            .subscribe(onNext: { _ in
                print("hoxvi begin")
                self.clearView.isHidden = false
            }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "SearchHistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchHistoryCell")
        tableView.rowHeight = 40
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfSearchHistoryData> { dataSource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "SearchHistoryCell") as! SearchHistoryCell
            cell.lblTitle.text = item.title
            
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        SearchHistoryViewModel.shared.searchHistory
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(SearchHistoryItem.self)
            .subscribe(onNext: { model in
                self.textField.text = model.title
            }).disposed(by: disposeBag)
        
        tableView.rx
            .itemDeleted
            .subscribe(onNext: { indexPath in
                CoreDataManager.shared.deleteSearchHistory(indexPath.row)
                self.checkEmpty()
            }).disposed(by: disposeBag)
    }
    
    private func setupTapEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        clearView.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        btnSearch.rx.tap
            .bind {
                let item = self.textField.text
                if item != nil && item != "" {
                    CoreDataManager.shared.saveSearchHistory(item: item, date: Date())
                    self.goToMap()
                }
            }.disposed(by: disposeBag)
    }
    
    private func goToMap() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        vc.query = self.textField.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func checkEmpty() {
        let history = CoreDataManager.shared.loadSearchHistory()
        tableView.isHidden = history.isEmpty
    }
}

extension SearchViewController: UIScrollViewDelegate, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderView()
        view.lblTitle.text = self.dataSource.sectionModels[section].header
        return view
    }
}
