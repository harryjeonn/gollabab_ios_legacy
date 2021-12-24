//
//  CalendarCell.swift
//  GollaBab
//
//  Created by 전현성 on 2021/12/29.
//

import UIKit

class CalendarCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblMemo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.textColor = .themeColor
        lblTitle.font = UIFont(name: "EliceDigitalBaeumOTF", size: 15)
        
        lblMemo.textColor = .lightGray
        lblMemo.font = UIFont(name: "EliceDigitalBaeumOTF", size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
