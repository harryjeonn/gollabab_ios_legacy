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
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.tintColor = .whiteColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.whiteColor]
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
