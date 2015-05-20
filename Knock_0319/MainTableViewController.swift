//
//  Test1TableViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/19.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    var titles: Array<titletest> = []
    var test1 = titletest()
    var test2 = titletest()
    var test3 = titletest()
    var test4 = titletest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("start")
        test2.title = "test for stringtest for stringtest for stringtest for stringtest for stringtest for stringtest for stringtest for stringtest for stringtest for string"
        test3.picture = nil
        test4.picture = UIImagePNGRepresentation(UIImage(named: "color1.jpg"))
        titles.append(test1)
        titles.append(test2)
        titles.append(test3)
        titles.append(test4)
        
        
        tableView.reloadData()
        
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.titles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! MainTableViewCell
        let title = self.titles[indexPath.row]
        cell.nameLabel.text = title.account
        cell.boardLabel.text = title.board
        cell.titleLabel.text = title.title
        cell.timeLabel.text = title.time.description
        cell.numberLabel.text = "36個讚  1則回覆  20篇文章"
        //setup avator icon
        if let icon = title.icon {
            cell.iconImage.image = UIImage(data: icon)
        }else {
            //setup random color avator
            cell.iconImage.image = setupAvatorImage(cell.nameLabel.text!.hash)
        }
        //setup picture & height
        if let data = titles[indexPath.row].picture {
            if let image = UIImage(data: data) {
                cell.titleimage.image = image
                let ratio = image.size.width / image.size.height
                cell.imageHeightConst.constant = cell.frame.width / ratio
            }
        }else {
            //no picture
            cell.titleimage.image = nil
            cell.imageHeightConst.constant = 0
        }
        
        //setup tag
        cell.iconImage.tag = indexPath.row
        cell.nameLabel.tag = indexPath.row
        cell.titleimage.tag = indexPath.row
        cell.boardLabel.tag = indexPath.row
        cell.starButton.tag = indexPath.row
        cell.sendButton.tag = indexPath.row
        cell.pushButton.tag = indexPath.row
        
        //circle icon
        cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.width / 2
        cell.iconImage.clipsToBounds = true
        
        //setup tap gesture
        let tapIcon = UITapGestureRecognizer(target: self, action: "iconViewTouch:")
        let tapName = UITapGestureRecognizer(target: self, action: "iconViewTouch:")
        cell.iconImage.addGestureRecognizer(tapIcon)
        cell.nameLabel.addGestureRecognizer(tapName)
        
        return cell
    }
    
    //setup cell height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //basic              top - icon -- label --pic-- label2 --  bar
        var height: CGFloat = 15 + 50 + 20 + 0 + 10 + 10 + 16 + 10 + 40
        let title = titles[indexPath.row]
        //label front height
        if let text = title.title {
            let font = UIFont.systemFontOfSize(17)
            let textHeight = lineHeightForString(text, myFront: font, myWidth: (tableView.frame.width - 40))
            height += textHeight
        }
        
        //image height
        if let data = titles[indexPath.row].picture {
            if let image = UIImage(data: data) {
                
                let ratio = image.size.width / image.size.height
                
                height += tableView.frame.width / ratio
                
            }
        }
        
        //label2 height
        
        
        return height
    }
    
    // read label height
    func lineHeightForString(myString: String, myFront: UIFont, myWidth: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRectMake(0, 0, myWidth, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = myFront
        label.text = myString
        
        label.sizeToFit()
        return label.frame.height
    }

    //setup colors avator
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
    
    
    
    
    //button setup
    //icon image touch
    func iconViewTouch(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            //tap on icon image
            if let row = sender.view?.tag {
                println("tap on icon at row: " + row.description)
                
                
            }
        }
    }
    
    //starButton touch
    @IBAction func starButtonTouch(sender: AnyObject) {
        if let row = sender.tag {
            println("touch star at row: " + row.description)
            
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? MainTableViewCell {
                //delete from star
                if cell.starButton.image == UIImage(named: "star-fill-vec") {
                    //remove favor article
                    cell.starButton.image = UIImage(named: "star-vec")
                    //delete mydata
                    
                    
                    return
                }
                
                
                //add to star
                
                
                //animate
                cell.starButton.image = UIImage(named: "star-fill-vec")
                let snapshot = cell.snapshotViewAfterScreenUpdates(true)
                let cellFrame = cell.frame
                snapshot.frame = cellFrame
                let smallFrame = CGRectInset(cellFrame, cellFrame.size.width / 3, cellFrame.size.height / 3)
                let finalFrame = CGRectOffset(smallFrame, self.view.bounds.size.width / 2, self.view.bounds.size.height)
                view.addSubview(snapshot)
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
    
    
    //pushButton touch
    @IBAction func pushButtonTouch(sender: AnyObject) {
        if let row = sender.tag {
            println("touch push at row: " + row.description)
        }
    }
    
    //sendButton touch
    @IBAction func sendButtonTouch(sender: AnyObject) {
        if let row = sender.tag {
            println("touch send at row: " + row.description)
        }
    }
    
    
    
    
}
