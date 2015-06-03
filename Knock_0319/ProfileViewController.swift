//
//  ProfileViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var iconImage: UIImageView!

    @IBOutlet weak var AccountLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var backGroundImage: UIImageView!
    
    @IBOutlet weak var profileSetButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconImage.layer.cornerRadius = 30
        self.iconImage.clipsToBounds = true
        self.view.bringSubviewToFront(self.AccountLabel)
        self.view.bringSubviewToFront(self.descriptionLabel)
        self.view.bringSubviewToFront(self.iconImage)
        //blur button
        //blurr
        let blureffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blureffect)
        blurView.frame = CGRect(x: self.view.frame.width - 75, y: 165, width: 65, height: 30)
        
        blurView.layer.cornerRadius = 3
        blurView.clipsToBounds = true
        self.view.addSubview(blurView)
        //self.view.bringSubviewToFront(blurView)
        self.view.bringSubviewToFront(self.profileSetButton)
        
        // Do any additional setup after loading the view.
        
        //test
        self.AccountLabel.text = "ipalm@ptt.cc"
        self.descriptionLabel.text = "五篇文章，109個追隨者"
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
