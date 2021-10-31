//
//  OpenSourceDetailViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/31.
//

import UIKit

class OpenSourceDetailViewController: BaseViewController {
    @IBOutlet var textView: UITextView!
    
    var naviTitle = ""
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
        textView.backgroundColor = .bgColor
        textView.font = UIFont(name: "EliceDigitalBaeumOTF", size: 15)
        textView.isEditable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = naviTitle
    }
}
