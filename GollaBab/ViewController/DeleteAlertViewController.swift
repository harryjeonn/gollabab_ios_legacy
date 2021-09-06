//
//  DeleteAlertViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/09/06.
//

import UIKit
import RxSwift
import RxCocoa

class DeleteAlertViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertViewWidth: NSLayoutConstraint!
    @IBOutlet weak var alertViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    private let disposeBag = DisposeBag()
    var section = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapEvent()
    }
    
    private func setupUI() {
        preferredContentSize = CGSize(width: alertViewWidth.constant + 40, height: alertViewHeight.constant)
        self.view.backgroundColor = .bgColor
        alertView.backgroundColor = .bgColor
        
        stackView.subviews.forEach { button in
            let button = button as! UIButton
            button.setTitleColor(.whiteColor, for: .normal)
            button.layer.cornerRadius = 10
        }
        btnDelete.backgroundColor = .red
        btnCancel.backgroundColor = .lightTextColor
    }
    
    private func setupTapEvent() {
        btnDelete.rx.tap
            .bind {
                CoreDataManager.shared.deleteHistory(self.section)
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        btnCancel.rx.tap
            .bind {
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
    
}
