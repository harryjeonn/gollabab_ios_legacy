//
//  HeaderView.swift
//  GollaBab
//
//  Created by 전현성 on 2021/09/03.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        let view = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.backgroundColor = .clear
        lblTitle.textColor = .themeColor
        addSubview(view)
    }
}
