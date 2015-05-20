//
//  flowTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/11.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var account: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
   
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    @IBOutlet weak var pushButton: UIBarButtonItem!
    
    
    
    var pictureHeight: CGFloat!
    var pictureWidth: CGFloat!
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                picture.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                picture.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    //setup for picture(with or without picture)
    func setPostedImage(image : UIImage?) {
        if let image = image {
            //have image
            var aspect = image.size.width / image.size.height
            pictureHeight = self.frame.width / aspect
            pictureWidth = self.frame.width
            println("picture height " + pictureHeight.description + "picture width " + pictureWidth.description)
            
            var aspectConstraint = NSLayoutConstraint(item: picture, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: picture, attribute: NSLayoutAttribute.Height, multiplier: aspect, constant: 0.0)
            aspectConstraint.priority = 999
            
            picture.image = image
            
        }else {
            //no image
            println("no image, cell width = " + self.frame.width.description)
            aspectConstraint = nil
            picture.image = nil
            /*
            aspectConstraint = NSLayoutConstraint(item: picture, attribute: .Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 0.0)
            */
            //titleLabelConstraint.constant = 0
            //self.picture.hidden = true
            //self.pictureHeight.constant = 0
            
            //self.picture.removeConstraint(self.pictureAspectRatioConst)
            //self.pictureAspectRatioConst.constant = 1
            
            //self.layoutIfNeeded()
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
