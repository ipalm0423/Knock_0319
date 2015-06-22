//
//  SimpleProfileViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/15.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import TWMessageBarManager
class SimpleProfileViewController: UIViewController {

    
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var followerButton: UIButton!
    
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var greenLabel: UILabel!
    
    
    var user = userInfoTemp() {
        didSet{
            self.accountLabel.text = user.account
            self.subLabel.text = user.name
            self.redLabel.text = user.redPush.description
            self.greenLabel.text = user.greenPush.description
            self.chatButton.setTitle(self.user.totalTitle?.description, forState: UIControlState.Normal)
            self.followerButton.setTitle(self.user.follower?.description, forState: UIControlState.Normal)
            if (user.redPush + user.greenPush) > 0 {
                var ratio = Float(user.redPush) / Float(user.redPush + user.greenPush)
                self.progressBar.progress = ratio
            }
        }
    }
    var isFollow = false {
        didSet{
            if isFollow == true {
                self.followingButton.setTitle("", forState: UIControlState.Normal)
                self.followingButton.backgroundColor = UIColor.greenColor()
                self.followingButton.setImage(UIImage(named: "tick-vec"), forState: UIControlState.Normal)
            }else {
                self.followingButton.setTitle("追蹤", forState: UIControlState.Normal)
                self.followingButton.backgroundColor = UIColor.orangeColor()
                self.followingButton.setImage(UIImage(named: "dart-28-vec"), forState: UIControlState.Normal)
                self.followingButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            }
        }
    }
    var account = "" {
        didSet{
            if let user = Singleton.sharedInstance.searchFollower(self.account) {
                self.user = user
                
                self.isFollow = user.isFollow!
                println("finded in data: " + account)
            }
            //query user from server
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.icon.layer.cornerRadius = 30
        self.icon.clipsToBounds = true
        self.progressBar.layer.cornerRadius = 7.5
        self.progressBar.clipsToBounds = true
        self.followingButton.layer.cornerRadius = 5
        self.followingButton.clipsToBounds = true
        self.view.layer.cornerRadius = 5
        self.view.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeButtonTouch:", name: "closeSimpleProfile", object: nil)
        Singleton.sharedInstance.isSimpleViewOpen = true
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTouch(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.frame.offset(dx: 0, dy: 500)
        }) { (Bool) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            Singleton.sharedInstance.isSimpleViewOpen = false
        }
    }

    
    @IBAction func followingButtonTouch(sender: AnyObject) {
        if self.user.account == nil {
            return
        }
        
        if self.isFollow == true {
            //unfollow target
            self.isFollow = false
            TWMessageBarManager.sharedInstance().showMessageWithTitle("取消追蹤", description: self.accountLabel.text, type: TWMessageBarMessageType.Info)
            
            
            //delete from coredata
            Singleton.sharedInstance.deleteFollower(self.account)
        }else {
            //follow target animate
            self.isFollow = true
            TWMessageBarManager.sharedInstance().showMessageWithTitle("追蹤使用者", description: self.accountLabel.text, type: TWMessageBarMessageType.Success)
            
            
            //add to core data
            Singleton.sharedInstance.saveFollower(user)
        }
        
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
