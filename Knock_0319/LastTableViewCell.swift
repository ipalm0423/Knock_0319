//
//  LastTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/24.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class LastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var pushField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
