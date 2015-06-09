//
//  SmallTableViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/8.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class SmallTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    //board information
    var boardinfo: boardInfo!
    var titles: Array<titletest> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        
        //test
        var titlet = titletest()
        self.titles.append(titlet)
        titlet.pushNumber = "9"
        titles.append(titlet)
        titlet.pushNumber = "30"
        titles.append(titlet)
        titlet.pushNumber = "60"
        titles.append(titlet)
        titlet.pushNumber = "100"
        titlet.title = "我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長我超長"
        titles.append(titlet)
        titlet.picture = nil
        titles.append(titlet)
        titlet.pushNumber = "-9"
        titles.append(titlet)
        titlet.pushNumber = "-30"
        titles.append(titlet)
        titlet.pushNumber = "-60"
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func menuButtonTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("UnwindToBoardMenu", sender: self)
    }
    
    
    
    
    //table delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SmallTableCell", forIndexPath: indexPath) as! SmallTableViewCell
        let title = self.titles[indexPath.row]
        
        cell.setupPushLabel(title.pushNumber)
        cell.timeLabel.text = title.time.description
        cell.idTitle.text = title.account
        cell.subTitle.text = title.type
        cell.mainTitle.text = title.title
        if let data = title.picture {
            cell.picture.image = UIImage(data: data)
        }
        
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SmallDetailSeague" {
            if let indexpath = self.tableView.indexPathForSelectedRow() {
                if let VC = segue.destinationViewController as? DetailTitleViewController {
                    VC.titleinfo = self.titles[indexpath.row]
                }
            }
        }
    }

}
