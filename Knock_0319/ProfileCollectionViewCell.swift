//
//  ProfileCollectionViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var pushLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var blurView: UIVisualEffectView!
    
    func setupPicture(data: NSData?) {
        
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        blurView?.removeFromSuperview()
    }
    
}
