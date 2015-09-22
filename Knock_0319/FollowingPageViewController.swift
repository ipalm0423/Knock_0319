//
//  FollowingPageViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import CoreData

class FollowingPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let pageControl = 3
    
    @IBOutlet weak var tableView: UITableView!
    
    var followers = [Userinfo]()
    var fetchResultController: NSFetchedResultsController!
    var fetchRequest = NSFetchRequest(entityName: "Userinformation")
    let sortDescription = NSSortDescriptor(key: "account", ascending: true)
    let isUserPredicate = NSPredicate(format: "isUser == %@", NSNumber(bool: false))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //load from core data
        self.loadFollowerData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadFollowerData()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("closeSimpleProfile", object: nil)
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
        
        cell.user = user
        
        cell.icon.layer.cornerRadius = 20
        cell.icon.clipsToBounds = true
        cell.followButton.layer.cornerRadius = 5
        cell.followButton.clipsToBounds = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if Singleton.sharedInstance.isSimpleViewOpen == false {
            let account = self.followers[indexPath.row].account
            Singleton.sharedInstance.ShowProfileView(account!)
            
        }else {
            NSNotificationCenter.defaultCenter().postNotificationName("closeSimpleProfile", object: nil)
            tableView.reloadData()
            
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
    
    func loadFollowerData() {
        if let MOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            self.fetchRequest.sortDescriptors = [self.sortDescription]
            self.fetchRequest.predicate = self.isUserPredicate
            self.fetchResultController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: MOC, sectionNameKeyPath: nil, cacheName: nil)
            var e: NSError?
            if !self.fetchResultController.performFetch(&e) {
                println(e?.localizedDescription)
            }
            self.followers = self.fetchResultController.fetchedObjects as! [Userinfo]
        }
    }

}
