//
//  FollowingPageViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class FollowingPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let pageControl = 3
    
    @IBOutlet weak var tableView: UITableView!
    
    var followers = [userInfoTemp]()
    var simpleProfileIsOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //test
        var user1 = userInfoTemp()
        
        self.followers.append(user1)
        user1.picture = nil
        self.followers.append(user1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeSimpleProfile:", name: "closeSimpleProfile", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeSimpleProfile", object: nil)
    }
    
    func closeSimpleProfile(notify: NSNotification) {
        self.simpleProfileIsOpen = false
    }
    
    //table view delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("followingCell", forIndexPath: indexPath) as! FollowingTableViewCell
        let user = self.followers[indexPath.row]
        cell.accountLabel.text = user.account
        if let data = user.picture {
            cell.icon.image = UIImage(data: data)
        }else {
            cell.icon.image = Singleton.sharedInstance.setupAvatorImage(user.account!.hash)
        }
        cell.icon.layer.cornerRadius = 20
        cell.icon.clipsToBounds = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.simpleProfileIsOpen == false {
            let account = self.followers[indexPath.row].account
            Singleton.sharedInstance.ShowProfileView(account!)
            self.simpleProfileIsOpen = true
        }else {
            
            return
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
