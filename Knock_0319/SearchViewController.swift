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
    var sections = ["清新健康", "現約板", "匿名板", "個人看板"]
    var boardinfos = [String: Array<boardInfo>]()
    var boards = boardInfo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        //test
        self.boardinfos = ["清新健康":[boards, boards], "現約板":[boards, boards, boards, boards, boards]]
        
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
        if let boards = self.boardinfos[sections[section]] {
            //has board
            return 1
        }
        //no board
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("boardCell", forIndexPath: indexPath) as! CollectionTableViewCell
        cell.boardinfo = self.boardinfos[sections[indexPath.section]]!
        cell.collectionView.delegate = cell
        cell.collectionView.dataSource = cell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
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
