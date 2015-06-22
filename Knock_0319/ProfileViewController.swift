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
    
    @IBOutlet weak var blurImage: UIImageView!
    
    @IBOutlet weak var greenPushLabel: UILabel!
    
    @IBOutlet weak var redPushLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var backGroundPictureTopConst: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(self.backGroundImage)
        self.iconImage.layer.cornerRadius = 30
        self.iconImage.clipsToBounds = true
        
        //blur button
        //blurr
        let blureffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blureffect)
        blurView.frame = self.blurImage.bounds
        blurView.layer.cornerRadius = 3
        blurView.clipsToBounds = true
        self.blurImage.addSubview(blurView)
        self.view.bringSubviewToFront(self.profileSetButton)
        //process bar
        self.progressBar.layer.cornerRadius = 10
        self.progressBar.clipsToBounds = true
        
        
        
        // Do any additional setup after loading the view.
        
        //test
        self.AccountLabel.text = "ipalm@ptt.cc"
        self.descriptionLabel.text = "五篇文章，109個追隨者"
        self.redPushLabel.text = "1230"
        self.greenPushLabel.text = "600"
        self.progressBar.progress = 0.4
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeBackGroundPicture:", name: "closeProfilePicture", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openBackGroundPicture:", name: "openProfilePicture", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeProfilePicture", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "openProfilePicture", object: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func closeBackGroundPicture(notify: NSNotification) {
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.backGroundPictureTopConst.constant -= 240
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func openBackGroundPicture(notify: NSNotification) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.backGroundPictureTopConst.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
}
