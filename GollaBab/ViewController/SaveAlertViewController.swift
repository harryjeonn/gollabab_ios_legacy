//
//  SaveAlertViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/08/09.
//

import UIKit
import RxSwift
import RxCocoa

enum AlertType {
    case vote
    case calendar
    case calendarEdit
    
    func title() -> String {
        switch self {
        case .vote:
            return "투표 이름"
        case .calendar:
            return "추가"
        case .calendarEdit:
            return "편집"
        }
    }
    
    func progressTitle() -> String {
        switch self {
        case .vote:
            return "저장 중"
        case .calendar:
            return "추가 중"
        case .calendarEdit:
            return "편집 중"
        }
    }
    
    func successTitle() -> String {
        switch self {
        case .vote:
            return "저장 완료"
        case .calendar:
            return "추가 완료"
        case .calendarEdit:
            return "편집 완료"
        }
    }
    
    func failTitle() -> String {
        switch self {
        case .vote:
            return "저장 실패"
        case .calendar:
            return "추가 실패"
        case .calendarEdit:
            return "편집 실패"
        }
    }
}

class SaveAlertViewController: UIViewController {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertViewWidth: NSLayoutConstraint!
    @IBOutlet weak var alertViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var memoTextField: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var alertType: AlertType!
    var editItem: CalendarItem?
    
    var isInput: Bool! {
        didSet {
            nameTextField.isHidden = isInput
            memoTextField.isHidden = isInput
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
        nameTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe { _ in
                
            }.disposed(by: disposeBag)
        
        memoTextField.rx
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
        lblTitle.text = alertType.title()
        
        btnCancel.backgroundColor = .lightTextColor
        
        memoTextField.placeholder = "메모를 남길 수 있어요."
        
        if alertType == .vote {
            memoTextField.isHidden = true
        }
        
        if let item = editItem {
            nameTextField.placeholder = item.title
            memoTextField.placeholder = item.memo
        }
    }
    
    private func saveVote() {
        if nameTextField.text != "" {
            isInput = true
            lblTitle.text = alertType.progressTitle()
            HistoryViewModel.shared.title = nameTextField.text
            CoreDataManager.shared.saveHistory()
            subscribeResult()
        }
    }
    
    private func saveCalendar() {
        if nameTextField.text != "" {
            isInput = true
            lblTitle.text = alertType.progressTitle()
            CalendarViewModel.shared.title = nameTextField.text
            CalendarViewModel.shared.memo = memoTextField.text
            CalendarViewModel.shared.saveCalendarData()
            subscribeResult()
        }
    }
    
    private func editCalendar() {
        guard let editItem = editItem else { return }
        if nameTextField.text != "" {
            isInput = true
            lblTitle.text = alertType.progressTitle()
            CalendarViewModel.shared.deleteCalendarData(date: editItem.date, title: editItem.title, memo: editItem.memo)
            CalendarViewModel.shared.date = editItem.date
            CalendarViewModel.shared.title = nameTextField.text
            CalendarViewModel.shared.memo = memoTextField.text
            CalendarViewModel.shared.saveCalendarData()
            subscribeResult()
        }
    }
    
    private func saveCoreData() {
        dismissKeyboard()
        switch alertType {
        case .vote:
            saveVote()
        case .calendar:
            saveCalendar()
        case .calendarEdit:
            editCalendar()
        default:
            break
        }
    }
    
    private func subscribeResult() {
        CoreDataManager.shared.isSuccess.subscribe(onNext: { res in
            if res {
                self.lblTitle.text = self.alertType.successTitle()
            } else {
                self.lblTitle.text = self.alertType.failTitle()
            }
            self.btnConfirm.isHidden = false
        }).disposed(by: disposeBag)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
