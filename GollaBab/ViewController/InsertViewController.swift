//
//  InsertViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/18.
//

import UIKit
import RxSwift
import RxCocoa

class InsertViewController: BaseViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var lblEmpty: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupTableView()
        setupTapEvent()
        ItemViewModel.shared.rxInit()
        setUI()
        emptyView.isHidden = !ItemViewModel.shared.eventItems.value.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "입력"
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "InsertCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "InsertCell")
        tableView.rowHeight = 40
        ItemViewModel.shared.eventItems.accept(items)
        
        ItemViewModel.shared.eventItems
            .bind(to: tableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "InsertCell") as! InsertCell
                cell.lblItem.text = item
                cell.lblItem.textColor = .themeColor
                cell.backgroundColor = .clear
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx
            .itemDeleted
            .subscribe(onNext: { item in
                self.items.remove(at: item.row)
                ItemViewModel.shared.items.onNext(self.items)
                self.emptyView.isHidden = !ItemViewModel.shared.eventItems.value.isEmpty
            }).disposed(by: disposeBag)
    }
    
    private func setupTextField() {
        textField.rx
            .controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { _ in
                self.addItem()
            }).disposed(by: disposeBag)
    }
    
    private func addItem() {
        if textField.text != "" {
            guard let text = self.textField.text else { return }
            items.insert(text, at: 0)
            ItemViewModel.shared.items.onNext(items)
        }
        emptyView.isHidden = !ItemViewModel.shared.eventItems.value.isEmpty
        self.textField.text = nil
    }
    
    private func setupTapEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnPlus.rx.tap
            .bind {
                self.addItem()
            }.disposed(by: disposeBag)
        
        btnStart.rx.tap
            .bind {
                if !self.items.isEmpty {
                    print("Tap start")
                    HistoryViewModel.shared.items = self.items
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Result") as? ResultViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func setUI() {
        btnStart.layer.cornerRadius = 10
        btnStart.backgroundColor = .themeColor
        btnStart.setTitle("시작", for: .normal)
        btnStart.setTitleColor(.whiteColor, for: .normal)
        
        tableView.backgroundColor = .clear
        tableView.tintColor = .themeColor
        
        textField.textColor = .themeColor
        
        emptyView.backgroundColor = .bgColor
        
        lblEmpty.font = UIFont(name: "EliceDigitalBaeumOTF", size: 16)
        lblEmpty.text = "항목을 입력해주세요."
        lblEmpty.textColor = .themeColor
    }
}
