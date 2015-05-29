//
//  TopTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/24.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImageView(image: UIImage) {
        let aspect = image.size.width / image.size.height
        var pictureAspectConst = NSLayoutConstraint(item: self.topImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.topImageView, attribute: NSLayoutAttribute.Height, multiplier: aspect, constant: 0.0)
        self.topImageView.image = image
        self.topImageView.addConstraint(pictureAspectConst)
    }
    
}
