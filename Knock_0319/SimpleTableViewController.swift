//
//  SimpleTableViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/11.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class SimpleTableViewController: UITableViewController {
    
    //table para
    var sections = Singleton.sharedInstance.sections
    var boardinfos = Singleton.sharedInstance.boardinfos
    var boards = boardInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight =  30
        
        //test
        self.boardinfos = ["最熱門":[boards, boards], "逗趣搞笑":[boards, boards, boards, boards, boards], "我的最愛": [boards, boards, boards, boards, boards]]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let boards = self.boardinfos[sections[section]] {
            return boards.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleCell", forIndexPath: indexPath) as! SimpleCellTableViewCell
        let board = self.boardinfos[sections[indexPath.section]]![indexPath.row]
        cell.Label.text = board.name
        cell.board = board
        

        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleSection") as! SimpleSectionTableViewCell
        cell.Label.text = self.sections[section]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SmallTableSegueByMain" {
            if let cell = sender as? SimpleCellTableViewCell {
                println("selected board: " + cell.board.id!)
                if let VC = segue.destinationViewController as? SmallTableViewController {
                    VC.boardinfo = cell.board
                    //close board bar item
                    VC.navigationBar.setLeftBarButtonItem(nil, animated: false)
                }
            }
        }
    }
    

}
