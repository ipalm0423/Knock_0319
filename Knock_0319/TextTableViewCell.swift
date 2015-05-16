//
//  AccountTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/14.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    
    @IBOutlet weak var rowLabel: UILabel!
    
    
    @IBOutlet weak var rowField: UITextField!
    
    @IBAction func textFieldRetur(sender: AnyObject) {
        sender.resignFirstResponder()
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
