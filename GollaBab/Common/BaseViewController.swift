//
//  BaseViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/18.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupNaviBar() {
        guard let titleFont: UIFont = UIFont(name: "EliceDigitalBaeumOTF-Bd", size: 15) else { return }
        navigationController?.navigationBar.tintColor = .themeColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : titleFont,
            NSAttributedString.Key.foregroundColor : UIColor.themeColor
        ]
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_home"), style: .plain, target: self, action: #selector(goHome))
    }
    
    private func setupBackgroundColor() {
        view.backgroundColor = .bgColor
    }
    
    @objc func goHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
