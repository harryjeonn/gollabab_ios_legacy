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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupTextField()
        setupTapEvent()
    }
    
    private func setupTextField() {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                self.addItem()
            }).disposed(by: disposeBag)
    }
    
    private func addItem() {
        
    }
    
    private func setupTapEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnPlus.rx.tap
            .bind {
                print("Tap plus")
            }.disposed(by: disposeBag)
        
        btnStart.rx.tap
            .bind {
                print("Tap start")
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
    }
}
