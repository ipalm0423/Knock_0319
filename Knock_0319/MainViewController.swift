//
//  MainViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/21.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var viewself: UIView!
    
    //simple table VC
    var simpleTableVC: SimpleTableViewController!
    var simpleTableIsShow = false
    
    //test
    var titles: Array<titletest> = []
    var test1 = titletest()
    var test2 = titletest()
    var test3 = titletest()
    var test4 = titletest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        
        
        //test
        test2.title = "test for stringtest for stringtest for stringtest for stringtest for stringtest for stringtest for stringtest for stringtest for stringtest for string"
        test3.picture = nil
        test4.picture = UIImagePNGRepresentation(UIImage(named: "color1.jpg"))
        titles.append(test1)
        titles.append(test2)
        titles.append(test3)
        titles.append(test4)
        titles.append(test1)
        titles.append(test2)
        titles.append(test3)
        titles.append(test4)
        titles.append(test1)
        titles.append(test2)
        titles.append(test3)
        titles.append(test4)
        tableView.reloadData()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("closeSimpleProfile", object: nil)
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
            cell.iconImage.image = Singleton.sharedInstance.setupAvatorImage(cell.nameLabel.text!.hash)
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
        //starbutton fill
        if title.isFavor == false {
            cell.starButton.image = UIImage(named: "star-vec")
        }else {
            cell.starButton.image = UIImage(named: "star-fill-vec")
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.simpleTableIsShow {
            self.removeSimpleTable()
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
    
    //icon image touch
    func iconViewTouch(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            //tap on icon image
            if let row = sender.view?.tag {
                println("tap on icon at row: " + row.description)
                if Singleton.sharedInstance.isSimpleViewOpen == false {
                    println(self.parentViewController?.description)
                    Singleton.sharedInstance.ShowProfileView(self.titles[row].account)
                }else {
                    return
                }
                
            }
        }
    }
    
    //starButton touch
    @IBAction func starButtonTouch(sender: AnyObject) {
        if let row = sender.tag {
            println("touch star at row: " + row.description)
            let title = self.titles[row]
            if title.isFavor == true {
                //return false
                titles[row].isFavor = false
                //delete favor at CoreData
                
                //send to server
                self.tableView.reloadData()
                return
            }else {
                //return true
                titles[row].isFavor = true
                //add favor at CoreData
                
                //send to server
                self.tableView.reloadData()
            }
            
            //animate
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? MainTableViewCell {
                //animate
                
                let snapshot = cell.snapshotViewAfterScreenUpdates(true)
                let cellBounds = cell.convertRect(cell.bounds, toView: self.view)
                snapshot.frame = cellBounds
                //println(cellBounds.origin.y)
                //println(cellBounds.size.height)
                
                let smallFrame = CGRectInset(cellBounds, cellBounds.size.width / 3, cellBounds.size.height / 3)
                let finalFrame = CGRectOffset(smallFrame, self.view.bounds.size.width / 2, self.view.bounds.size.height)
                view.addSubview(snapshot)
                UIView.animateKeyframesWithDuration(1.0, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                        snapshot.frame = smallFrame
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: { () -> Void in
                        snapshot.frame = finalFrame
                    })
                    self.view.layoutIfNeeded()
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
    
    
    //open simple board view 
    //or close simple board view
    @IBAction func boardsButtonTouch(sender: AnyObject) {
        if self.simpleTableIsShow {
            self.removeSimpleTable()
        }else {
            self.setupSimpleTable()
        }
    }
    
    
    
    //segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSeague" {
            if let indexpath = self.tableView.indexPathForSelectedRow() {
                if let VC = segue.destinationViewController as? DetailTitleViewController {
                    VC.titleinfo = self.titles[indexpath.row]
                    VC.sourceViewController = "MainViewController"
                }
            }
        }
    }
    
    //add simple Table to View
    func setupSimpleTable() {
        //input VC
        self.simpleTableVC = self.storyboard?.instantiateViewControllerWithIdentifier("SimpleTableViewController") as! SimpleTableViewController
        self.simpleTableVC.view.frame = CGRectMake(10, 20, self.view.frame.width / 2, self.view.frame.height - 50)
        self.simpleTableVC.view.layer.cornerRadius = 10
        self.simpleTableVC.view.clipsToBounds = true
        self.addChildViewController(simpleTableVC)
        self.view.addSubview(simpleTableVC.view)
        self.simpleTableVC.didMoveToParentViewController(self)
        self.simpleTableIsShow = true
    }
    
    //remove simple table
    func removeSimpleTable() {
        
        self.simpleTableVC.view.removeFromSuperview()
        self.simpleTableVC.removeFromParentViewController()
        self.simpleTableIsShow = false
    }
    
    
    //back from detail
    @IBAction func returnViewController(segue:UIStoryboardSegue) {
        if let detiailVC = segue.sourceViewController as? DetailTitleViewController {
            println("return to main view")
            //data feedback
        }
    }

}
