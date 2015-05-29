//
//  123ViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/29.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class ArticlePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int?
    
    var titleinfo: titletest?
    //content
    var typeContentArray = [String]()
    var contentArray = [String]()
    //push
    var typePushArray = [String]()
    var accountPushArray = [String]()
    var pushArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
        
        
        //test
        self.typeContentArray = ["text", "text", "text", "text", "url", "image"]
        self.contentArray = [" 韓MERS疑似患者　出境前往中國    韓國保健福祉部今日發布消息指出，一名曾接觸中東呼吸症候群冠狀病毒感染症(MERS)  患者的44歲男子，在前日出境前往中國。", "據《韓聯社》及《朝鮮日報》報導，這名男子是韓國第3例MERS患者的兒子、第4例患者  的弟弟，他曾在家中接受隔離觀察，被列入疑似患者的名單。韓國衛生當局在昨日在確認  該名男子出境後，根據《國際衛生條例》將該事實通知世界衛生組織西太平洋區域辦事處  (WPRO)和中國衛生當局，讓中國當局能採取相關措施。",  "另一方面，南韓當局也證實又有2名患者確診患上MERS，這些患者均通過首例患者被感染  ，由此韓國國內確診患者增至7人。",  "蘋果日報（施旖婕／綜合外電報導）","http://goo.gl/NeyiAZ", "http://imgur.com/RAe1865"]
        self.typePushArray = ["1", "-1", "0"]
        self.accountPushArray = ["rabbit83035", "PCcaduceus", "maime55"]
        self.pushArray = ["到中國傳染 然後中國遊客跑來台灣  太恐怖了", "支那會怕這小小的MERS?", "中國人要死一片 但是沒人知道了嗎"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //keyboard return
    @IBAction func returnKeyBoard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    

    //table delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //top cell
            return 1
        case 1:
            //content cell
            return self.contentArray.count
        case 2:
            //push cell
            return self.pushArray.count
        case 3:
            //last cell
            return 1
        default:
            return 0
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row = indexPath.row
        var section = indexPath.section
        if section == 1 {
            //content cell
            let cell = tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath) as! ContentTableViewCell
            let content = self.contentArray[indexPath.row]
            let contenttype = self.typeContentArray[indexPath.row]
            switch contenttype {
            case "text" :
                cell.textContent.text = content
            case "image" :
                cell.textContent.text = content
            case "url" :
                cell.textContent.text = content
            default:
                println("unknow content")
            }
            return cell
        }else if section == 2 {
            //push cell
            let cell = tableView.dequeueReusableCellWithIdentifier("pushCell", forIndexPath: indexPath) as! PushTableViewCell
            let pushType = self.typePushArray[indexPath.row]
            cell.contentLabel.text = self.pushArray[indexPath.row]
            cell.idLabel.text = self.accountPushArray[indexPath.row]
            cell.replyLabel.text = "1則回覆"
            switch pushType {
            case "1" :
                cell.contentLabel.textColor = UIColor.greenColor()
            case "-1" :
                cell.contentLabel.textColor = UIColor.redColor()
            default:
                cell.contentLabel.textColor = UIColor.blackColor()
            }
            return cell
        }else if section == 0 {
            //top cell
            let cell = tableView.dequeueReusableCellWithIdentifier("topCell", forIndexPath: indexPath) as! TopTableViewCell
            if let title = self.titleinfo {
                cell.topLabel.text = title.title
                cell.subLabel.text = title.time.description
                if let imagedata = title.picture {
                    if let picture = UIImage(data: imagedata) {
                        cell.setImageView(picture)
                    }
                }
            }else{
                cell.topLabel.hidden = true
                cell.subLabel.hidden = true
            }
            return cell
        }else {
            //last cell
            let cell = tableView.dequeueReusableCellWithIdentifier("lastCell", forIndexPath: indexPath) as! LastTableViewCell
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        
        case 1:
            return "content"
            
        case 2:
            return "文章評論"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 100
        }
        return UITableViewAutomaticDimension
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
