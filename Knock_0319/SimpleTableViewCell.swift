//
//  SimpleTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/11.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class SimpleCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Label: UILabel!
    
    var board: boardInfo!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
