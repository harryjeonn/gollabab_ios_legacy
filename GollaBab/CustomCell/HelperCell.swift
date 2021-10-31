//
//  HelperCell.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/31.
//

import UIKit

class HelperCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        self.backgroundColor = .bgColor
        self.selectionStyle = .none
        
        lblTitle.textColor = .themeColor
        lblTitle.font = UIFont(name: "EliceDigitalBaeumOTF-Bd", size: 18)
        lblDescription.textColor = .themeColor
        lblDescription.font = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
    }
    
}
