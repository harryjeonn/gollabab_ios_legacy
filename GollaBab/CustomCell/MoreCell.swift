//
//  MoreCell.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/23.
//

import UIKit

class MoreCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var button: UIButton!
    
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
        
        lblTitle.font = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
        
        let origImage = UIImage(named: "chevron.right")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .themeColor
        button.setTitle("", for: .normal)
    }
    
}
