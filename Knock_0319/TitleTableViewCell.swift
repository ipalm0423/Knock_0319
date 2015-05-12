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
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var push: UILabel!
    
    @IBOutlet weak var favorButton: UIButton!

    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var titleLabelConstraint: NSLayoutConstraint!
    
    
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
            let aspect = image.size.width / image.size.height
            
            aspectConstraint = NSLayoutConstraint(item: picture, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: picture, attribute: NSLayoutAttribute.Height, multiplier: aspect, constant: 0.0)
            
            picture.image = image
        }else {
            aspectConstraint = NSLayoutConstraint(item: picture, attribute: .Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 0.0)
            titleLabelConstraint.constant = 0
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
