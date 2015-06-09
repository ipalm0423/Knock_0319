//
//  SmallTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/8.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class SmallTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var idTitle: UILabel!
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var pushLabel: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    let rotation90 = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(-M_PI / 2))
    
    func setupPushLabel(push: String) {
        self.progressBar.transform = rotation90
        self.pushLabel.text = push
        
        if let number = push.toInt() {
            let count = Double(abs(number))
            let width = Double(count) * 0.01 * 20 + 20
            self.progressBar.progress = Float(count * 0.01)
            
            //setup color
            if number > 0 {
                self.progressBar.progressTintColor = UIColor.redColor()
                self.pushLabel.textColor = UIColor.redColor()
            }else {
                self.progressBar.progressTintColor = UIColor.greenColor()
                self.pushLabel.textColor = UIColor.greenColor()
            }
            //setup word
            if number > 99 {
                self.pushLabel.text = "爆"
                
            }
            if number < -99 {
                self.pushLabel.text = "噓"
                
            }
        }
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
