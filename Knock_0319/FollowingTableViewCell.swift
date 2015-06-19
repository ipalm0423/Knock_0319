//
//  FollowingTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/14.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var accountLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
