//
//  PlaceCell.swift
//  GollaBab
//
//  Created by 전현성 on 2021/09/23.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    let img: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "pencil")
        return imgView
    }()
    
    let lblPlaceName: UILabel = {
        let lblPlaceName = UILabel()
        lblPlaceName.textColor = .themeColor
        lblPlaceName.font = UIFont(name: "EliceDigitalBaeumOTF", size: 17)
        return lblPlaceName
    }()
    
    let lblAddressName: UILabel = {
        let lblAddressName = UILabel()
        lblAddressName.textColor = .themeColor
        lblAddressName.font = UIFont(name: "EliceDigitalBaeumOTF", size: 12)
        return lblAddressName
    }()
    
    let lblPhone: UILabel = {
       let lblPhone = UILabel()
        lblPhone.textColor = .themeColor
        lblPhone.font = UIFont(name: "EliceDigitalBaeumOTF", size: 12)
        return lblPhone
    }()
    
    let lblDistance: UILabel = {
       let lblDistance = UILabel()
        lblDistance.textColor = .themeColor
        lblDistance.font = UIFont(name: "EliceDigitalBaeumOTF", size: 12)
        lblDistance.textColor = .lightGray
        return lblDistance
    }()
    
    let lblCategory: UILabel = {
       let lblCategory = UILabel()
        lblCategory.textColor = .themeColor
        lblCategory.font = UIFont(name: "EliceDigitalBaeumOTF", size: 12)
        lblCategory.textColor = .lightGray
        
        return lblCategory
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
        self.backgroundColor = .bgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        contentView.addSubview(img)
        contentView.addSubview(lblPlaceName)
        contentView.addSubview(lblAddressName)
        contentView.addSubview(lblPhone)
        contentView.addSubview(lblDistance)
        contentView.addSubview(lblCategory)
        
        img.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            img.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            img.widthAnchor.constraint(equalToConstant: 64),
            img.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        lblPlaceName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblPlaceName.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15),
            lblPlaceName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            lblPlaceName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])
        
        lblAddressName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblAddressName.topAnchor.constraint(equalTo: lblPlaceName.bottomAnchor, constant: 8),
            lblAddressName.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15),
            lblAddressName.trailingAnchor.constraint(equalTo: lblDistance.leadingAnchor, constant: -8)
        ])
        
        lblPhone.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblPhone.topAnchor.constraint(equalTo: lblCategory.bottomAnchor, constant: 8),
            lblPhone.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15),
            lblPhone.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8)
        ])
        
        lblDistance.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblDistance.topAnchor.constraint(equalTo: lblPlaceName.bottomAnchor, constant: 8)
        ])
        
        lblCategory.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblCategory.topAnchor.constraint(equalTo: lblAddressName.bottomAnchor, constant: 8),
            lblCategory.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 15)
        ])
    }
}

