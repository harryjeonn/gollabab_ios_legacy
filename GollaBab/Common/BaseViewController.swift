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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.themeColor]
    }
    
    private func setupNaviBar() {
        self.navigationController?.navigationBar.barTintColor = .bgColor
        self.navigationController?.navigationBar.tintColor = .themeColor
    }
    
    private func setupBackgroundColor() {
        self.view.backgroundColor = .bgColor
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}