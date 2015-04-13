//
//  FirstViewController.swift
//  Knock_0319
//
//  Created by ipalm on 2015/3/20.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import CoreData


class FirstViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController:NSFetchedResultsController!
    var rooms:[Roominfo] = []
    
    
    
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        var fetchRequest = NSFetchRequest(entityName: "Roominfo")
        let sortDescription = NSSortDescriptor(key: "roomName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            var result = fetchResultController.performFetch(&e)
            rooms = fetchResultController.fetchedObjects as! [Roominfo]
            if result != true {
                println(e?.localizedDescription)
            }
            
        }
        
    }
    
    //cancel status bar
    override func viewWillAppear(animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        SingletonC.sharedInstance.checkSocketConnection(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //建立表格
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        println(rooms.count)
        return self.rooms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RoomListTableViewCell
        
        // Configure the cell...
        let room = rooms[indexPath.row]
     
       
        cell.roomName.text = room.roomName
        if let image = room.image {
            cell.roomImage.image = UIImage(data: image)
            // Circular image
            cell.roomImage.layer.cornerRadius = cell.roomImage.frame.size.width / 2
            cell.roomImage.clipsToBounds = true
        }else {
            cell.roomImage = nil
        }
        
        if room.unRead == 0 {
            
        cell.unReadLabel.text = nil
        //cell.roomTime.text = "\(room.time)"
        }else {
            cell.unReadLabel.text = room.unRead.stringValue
        }
        
        
        
        
        return cell
    }
    
    
    //導入左拉狀態欄
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    //左拉狀態
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        //設置share左邊按鈕
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Add", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let addMenu = UIAlertController(title: "Extend the Time of Room", message: nil, preferredStyle: .ActionSheet)
            let foreverAction = UIAlertAction(title: "Forever", style: UIAlertActionStyle.Default, handler: nil)
            let adayAction = UIAlertAction(title: "A Day", style: UIAlertActionStyle.Default, handler: nil)
            let aweekAction = UIAlertAction(title: "A Week", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            addMenu.addAction(foreverAction)
            addMenu.addAction(adayAction)
            addMenu.addAction(aweekAction)
            addMenu.addAction(cancelAction)
            
            self.presentViewController(addMenu, animated: true, completion: nil)
            }
        )
        
        //設置delete左邊按鈕
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete",handler: {
            (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            // Delete the row from the data source
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                
                let roomToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Roominfo
                managedObjectContext.deleteObject(roomToDelete)
                
                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("delete error: \(e!.localizedDescription)")
                }
            }
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 237.0/255.0, green: 75.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        shareAction.backgroundColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        default:
            tableView.reloadData()
        }
        
        rooms = controller.fetchedObjects as! [Roominfo]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        tableView.endUpdates()
    }
    
    //change Segue for disable tabBar
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChatRoom" {
            if let indexpath = self.tableView.indexPathForSelectedRow(){
                let chatRoomController = segue.destinationViewController as! ChatRoomViewController
                let room = self.rooms[indexpath.row]
                chatRoomController.roomID = room.roomID
                chatRoomController.roomName = room.roomName
                //hide buttom tab bar
                chatRoomController.hidesBottomBarWhenPushed = true
                
            }
        
        }
    }

    


}

