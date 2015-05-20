//
//  Test1TableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/19.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var boardLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var titleimage: UIImageView!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    @IBOutlet weak var pushButton: UIBarButtonItem!
    
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
