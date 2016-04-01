//
//  PISectionViewCell.swift
//  Insider 3
//
//  Created by Игорь Кузнецов on 01.04.16.
//  Copyright © 2016 PKMR. All rights reserved.
//

import UIKit

class PISectionViewCell: UITableViewCell {

    let title: UILabel = UILabel()
    let rate: UILabel = UILabel()
    let change: UILabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(title)
        self.addSubview(rate)
        self.addSubview(change)
        
        
        change.font = UIFont(name: "Helvetica", size: 14)
        change.textColor = UIColor.whiteColor()
        change.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(self).multipliedBy(0.14)
            make.centerY.equalTo(self)
        }
        
        rate.font = UIFont(name: "Helvetica", size: 14)
        rate.textColor = UIColor.whiteColor()
        rate.snp_makeConstraints { (make) in
            make.right.equalTo(change.snp_left).offset(-5)
            make.width.equalTo(self).multipliedBy(0.14)
            make.centerY.equalTo(self)
            
        }
        
        title.font = UIFont(name: "Helvetica", size: 14)
        title.textColor = UIColor.whiteColor()
        title.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.width.equalTo(self).multipliedBy(0.62)
            make.centerY.equalTo(self)
            
        }
        
        
        
        
        
        self.backgroundColor = UIColor.blackColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
