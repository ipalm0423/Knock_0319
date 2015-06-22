//
//  FollowingTableViewCell.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/14.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import TWMessageBarManager

class FollowingTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    //parameter
    var isFollow = true {
        didSet {
            if self.isFollow == true {
                self.followButton.setTitle("", forState: UIControlState.Normal)
                self.followButton.backgroundColor = UIColor.greenColor()
                self.followButton.setImage(UIImage(named: "tick-vec"), forState: UIControlState.Normal)
            }else {
                self.followButton.setTitle("追蹤", forState: UIControlState.Normal)
                self.followButton.backgroundColor = UIColor.orangeColor()
                self.followButton.setImage(UIImage(named: "dart-28-vec"), forState: UIControlState.Normal)
                self.followButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            }
        }
    }
    
   
    var user: Userinfo! {
        didSet {
            self.accountLabel.text = user.account
            if let isFollow = user.isFollow {
                self.isFollow = isFollow.boolValue
            }
            if let data = user.picture {
                self.icon.image = UIImage(data: data)
            }else {
                self.icon.image = Singleton.sharedInstance.setupAvatorImage(user.account!.hash)
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
    
    
    @IBAction func followButtonTouch(sender: AnyObject) {
        if let account = self.user.account {
            if self.isFollow == true {
                //unfollow target
                self.isFollow = false
                TWMessageBarManager.sharedInstance().showMessageWithTitle("取消追蹤", description: self.accountLabel.text, type: TWMessageBarMessageType.Info)
                
                
                //delete from coredata
                Singleton.sharedInstance.deleteFollower(account)
            }else {
                //follow target animate
                self.isFollow = true
                TWMessageBarManager.sharedInstance().showMessageWithTitle("追蹤使用者", description: self.accountLabel.text, type: TWMessageBarMessageType.Success)
                
                
                //add to core data
                let usertemp = Singleton.sharedInstance.userInfoToUserTemp(self.user)
                Singleton.sharedInstance.saveFollower(usertemp!)
            }
        }
    }
    

}
