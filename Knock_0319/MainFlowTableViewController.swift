//
//  MainFlowTableViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/11.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import CoreData

class MainFlowTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchResultController:NSFetchedResultsController!
    var titles: Array<titletest> = []
    var test1 = titletest()
    var test2 = titletest()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test2.picture = nil
        
        titles.append(test1)
        titles.append(test2)
        titles.append(test2)
        titles.append(test1)
        titles.append(test1)
        println(test1.account)
        tableView.reloadData()
        println(self.titles.count)
        
        //auto height for cell
        tableView.estimatedRowHeight = 330.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        
        println("did appear")
        tableView.reloadData()
        //reload new message
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.titles.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! TitleTableViewCell
        let title = self.titles[indexPath.row]
        cell.account.text = title.account
        cell.subtitle.text = title.time.description + title.board
        cell.title.text = title.title
        if let icon = title.icon {
            cell.icon.image = UIImage(data: icon)
        }else {
            
            cell.icon.image = setupAvatorImage(cell.account.hash)
        }
        if let picture = title.picture {
            
            cell.setPostedImage(UIImage(data: picture)!)
        }else {
            //cell.picture.constraints()
            //cell.picture.hidden = true
            cell.setPostedImage(nil)
        }
        
        //setup tag
        cell.icon.tag = indexPath.row
        cell.account.tag = indexPath.row
        cell.picture.tag = indexPath.row
        cell.subtitle.tag = indexPath.row
        cell.followButton.tag = indexPath.row
        cell.starButton.tag = indexPath.row
        cell.forwardButton.tag = indexPath.row
        cell.pushButton.tag = indexPath.row
        
        //de selection
        cell.selectionStyle = .None
        
        //picture to circle
        cell.icon.layer.cornerRadius = cell.icon.frame.size.width / 2
        cell.icon.clipsToBounds = true
        return cell
    }
    
    
    
    @IBAction func followButtonTouch(sender: AnyObject) {
        var row = sender.tag
        println("touch follow: " + row.description)
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? TitleTableViewCell {
            
        }
    }
    /*
    @IBAction func favorButtonTouch(sender: AnyObject) {
        var row = sender.tag
        println("touch favor: " + row.description)
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? TitleTableViewCell {
            let snapshot = cell.snapshotViewAfterScreenUpdates(false)
            let cellFrame = cell.frame
            snapshot.frame = cell.frame
            let smallFrame = CGRectInset(cellFrame, cellFrame.size.width / 4, cellFrame.size.height / 4)
            let finalFrame = CGRectOffset(smallFrame, 0, cell.bounds.size.height)
            view.addSubview(snapshot)
            
            println("add image")
            //animate...
            
            UIView.animateKeyframesWithDuration(2.0, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                    snapshot.frame = smallFrame
                })
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                    snapshot.frame = finalFrame
                })
            }, completion: nil)
        }
    }*/
    
    @IBAction func favorButtonTouch(sender: AnyObject) {
        var row = sender.tag
        println("touch star: " + row.description)
    }
    // favor button
    @IBAction func test(sender: AnyObject) {
        if let row = sender.tag {
            println(row.description)
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? TitleTableViewCell {
                cell.starButton.image = UIImage(named: "star-fill-vec")
                let snapshot = cell.snapshotViewAfterScreenUpdates(true)
                let cellFrame = cell.frame
                snapshot.frame = cellFrame
                let smallFrame = CGRectInset(cellFrame, cellFrame.size.width / 3, cellFrame.size.height / 3)
                let finalFrame = CGRectOffset(smallFrame, self.view.bounds.size.width / 2, self.view.bounds.size.height)
                view.addSubview(snapshot)
                //animate...
                
                UIView.animateKeyframesWithDuration(1.0, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                        snapshot.frame = smallFrame
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: { () -> Void in
                        snapshot.frame = finalFrame
                    })
                    }) { (Bool) -> Void in
                        snapshot.removeFromSuperview()
                }
            }
        }
    }
    
    
    @IBAction func forwardButtonTouch(sender: AnyObject) {
        var row = sender.tag
        println("touch forward: " + row.description)
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? TitleTableViewCell {
            
        }
    }
    
    @IBAction func pushButtonTouch(sender: AnyObject) {
        var row = sender.tag
        println("touch push: " + row.description)
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? TitleTableViewCell {
            
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupAvatorImage(hash: Int) -> UIImage {
        
        let r = CGFloat(Float((hash & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((hash & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(hash & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.3)
        var rect = CGRectMake(0, 0, 50, 50)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
