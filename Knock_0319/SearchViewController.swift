//
//  CollectionViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/6.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //table para
    var sections = ["最熱門", "我的最愛", "逗趣搞笑", "男女類別", "運動類別"]
    var boardinfos = [String: Array<boardInfo>]()
    var boards = boardInfo()
    var currentSelected: [Bool] = [true, true, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.navigationItem.leftBarButtonItem? = UIBarButtonItem(image: UIImage(named: "menu-28-vec"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        // Do any additional setup after loading the view.
        
        //test
        self.boardinfos = ["最熱門":[boards, boards], "逗趣搞笑":[boards, boards, boards, boards, boards], "我的最愛": [boards, boards, boards, boards, boards]]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    //tableView delegate & data
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("boardCell", forIndexPath: indexPath) as! CollectionTableViewCell
        
        cell.boardTitle.text = self.sections[indexPath.section]
        if self.boardinfos[sections[indexPath.section]] != nil {
            cell.boardinfo = self.boardinfos[sections[indexPath.section]]!
        }
        cell.collectionView.delegate = cell
        cell.collectionView.dataSource = cell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.currentSelected[indexPath.section] == true {
            return 180
        }
        return 40
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        //change selection
        if self.currentSelected[section] == true {
            self.currentSelected[section] = false
            
        }else {
            //load new boards from server
            
            
            
            self.currentSelected[section] = true
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SmallTableSegue" {
            if let cell = sender as? TitleCollectionViewCell {
                println("selected board: " + cell.boardID)
                if let VC = segue.destinationViewController as? SmallTableViewController {
                    VC.navigationBar.title = cell.boardName
                    
                    
                }
                
            }
        }
    }
    
    
    @IBAction func cancelToSearchViewController(segue:UIStoryboardSegue) {
        
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
