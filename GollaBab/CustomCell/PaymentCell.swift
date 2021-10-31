//
//  PaymentCell.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/31.
//

import UIKit

class PaymentCell: UITableViewCell {
    @IBOutlet var imgDescription: UIImageView!
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
        lblDescription.font = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
        lblDescription.textColor = .themeColor
        
        self.backgroundColor = .bgColor
        self.selectionStyle = .none
    }
}
