//
//  ViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/12.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUI()
        setTapEvent()
    }
    
    private func setUI() {
        self.view.backgroundColor = .bgColor
        lblTitle.textColor = .textColor
        
        btnStart.backgroundColor = .lightGray
        btnStart.setTitle("시작", for: .normal)
        btnStart.setTitleColor(.white, for: .normal)
        btnStart.layer.cornerRadius = 10
        
        btnHistory.backgroundColor = .lightGray
        btnHistory.setTitle("지난 투표", for: .normal)
        btnHistory.setTitleColor(.white, for: .normal)
        btnHistory.layer.cornerRadius = 10
    }

    private func setTapEvent() {
        
    }
    
}

