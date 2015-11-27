//
//  BKAddressViewCell.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/26.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class BKAddressViewCell: UITableViewCell {

    
    var nameLabel : UILabel!
    var scoreLabel : UILabel!
    var ID : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.nameLabel = UILabel(frame: CGRectMake(0,0,CGRectGetWidth(self.contentView.frame)/3,CGRectGetHeight(self.contentView.frame)))
        self.nameLabel.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(nameLabel)
        
        
        self.scoreLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 0, CGRectGetWidth(self.contentView.frame)/3,CGRectGetHeight(self.contentView.frame)))
        self.scoreLabel.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(scoreLabel)
        
        
        self.ID = UILabel(frame: CGRectMake(CGRectGetMaxX(self.scoreLabel.frame), 0, CGRectGetWidth(self.contentView.frame) / 3, CGRectGetHeight(self.contentView.frame)))
        self.ID.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(self.ID)
        
        
        
        
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
