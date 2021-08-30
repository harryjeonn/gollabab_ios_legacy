//
//  SaveAlertViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/08/09.
//

import UIKit
import RxSwift
import RxCocoa

class SaveAlertViewController: UIViewController {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertViewWidth: NSLayoutConstraint!
    @IBOutlet weak var alertViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var isInput: Bool! {
        didSet {
            textField.isHidden = isInput
            btnSave.isHidden = isInput
            btnCancel.isHidden = isInput
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapEvent()
        setupTextField()
    }
    
    private func setupTextField() {
        textField.rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe { _ in
                
            }.disposed(by: disposeBag)
    }
    
    private func setupUI() {
        preferredContentSize = CGSize(width: alertViewWidth.constant + 40, height: alertViewHeight.constant)
        self.view.backgroundColor = .bgColor
        alertView.backgroundColor = .bgColor
        
        stackView.subviews.forEach { button in
            let button = button as! UIButton
            button.setTitleColor(.whiteColor, for: .normal)
            button.backgroundColor = .themeColor
            button.layer.cornerRadius = 10
        }
        
        btnConfirm.isHidden = true
        isInput = false
        
        lblTitle.textColor = .themeColor
        btnCancel.backgroundColor = .lightTextColor
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func saveCoreData() {
        dismissKeyboard()
        if textField.text != "" {
            HistoryViewModel.shared.title = textField.text
            CoreDataManager.shared.saveHistory()
            isInput = true
            lblTitle.text = "저장 중"
            CoreDataManager.shared.isSuccess.subscribe(onNext: { res in
                if res {
                    self.lblTitle.text = "저장 완료"
                } else {
                    self.lblTitle.text = "저장 실패"
                }
                self.btnConfirm.isHidden = false
            }).disposed(by: disposeBag)
        }
    }
    
    private func setupTapEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnSave.rx.tap
            .bind {
                self.saveCoreData()
            }.disposed(by: disposeBag)
        
        let buttons = Observable.of(btnConfirm.rx.tap, btnCancel.rx.tap).merge()
        buttons.subscribe { _ in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
