//
//  SearchHistoryCell.swift
//  GollaBab
//
//  Created by 전현성 on 2021/11/24.
//

import UIKit

class SearchHistoryCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        lblTitle.font = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
    }
}
