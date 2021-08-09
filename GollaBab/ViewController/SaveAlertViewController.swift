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
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
