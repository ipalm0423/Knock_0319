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
        cell.followButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.favorButton.tag = indexPath.row
        cell.selectionStyle = .None
        cell.icon.layer.cornerRadius = cell.icon.frame.size.width / 2
        cell.icon.clipsToBounds = true
        return cell
    }
    
    
    
    @IBAction func followButtonTouch(sender: AnyObject) {
        var row = sender.tag.description
        println("touch follow: " + row)
    }
    
    @IBAction func favoriteButtonTouch(sender: AnyObject) {
    }
    
    @IBAction func shareButtonTouch(sender: AnyObject) {
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
