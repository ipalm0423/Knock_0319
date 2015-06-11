//
//  Singleton.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/31.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift
import CoreData
import TWMessageBarManager

class Singleton: NSObject, NSFetchedResultsControllerDelegate {
    let socket = SocketIOClient(socketURL: "http://122.116.90.83:30000", opts: nil)
    class var sharedInstance: Singleton {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Singleton? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Singleton()
        }
        return Static.instance!
    }
    
    
    //parameter
    
    
    //keyboard parameter
    var keyboardIsShow = false
    //user
    var userinfo: Userinfo!
    var userinfotemp = userInfoTemp()
    //var getedUserID: Bool = false
    //var userPicture: UIImage?
    var fetchResultController:NSFetchedResultsController!
    var user:[Userinfo] = []
    //var chattext: String = ""
    
    //message parameter
    var messageinformation: Messageinfo!
    //time parameter
    let dateFormatterString = "yyyy-MM-ddTHH:mm:ss.SSSZ"
    let dateFormatterTWString = "yyyy年 MM月dd日 HH:mm"
    let locale = NSLocale(localeIdentifier: "zh_Hant_TW")
    var dateFormater = NSDateFormatter()
    //finger button
    var fingerOffsetPoint = CGPoint(x: 0, y: 0) {
        didSet {
            //save to Core Data
            
        }
    }
    
    //section parameter
    var sections = ["最熱門", "我的最愛", "逗趣搞笑", "男女類別", "運動類別"]
    //                [sections: [boards]]
    var boardinfos = [String: Array<boardInfo>]()
    
    func connectToServer() {
        socket.on("connect", callback: { (data, ack) -> Void in
            println("event socket connect")
            //load user
            if self.loadUserInfo() {
                //登入, emit signin
                self.signIn()
            }else {
                //尚未申請帳號, emi mobile
                self.mobile()
            }
        })
        
        socket.on("disconnect", callback: { (data, ack) -> Void in
            println("event socket disconnect")
            TWMessageBarManager.sharedInstance().showMessageWithTitle("失去連線", description: "請確認網路連線", type: TWMessageBarMessageType.Error, duration: 0.5)
        })
        
        socket.on("mobile", callback: { (data, ack) -> Void in
            println("event mobile")
            let cur = JSON(data!)
            let res = cur[0]["res"].stringValue
            if res == "0" {
                let sid = cur[0]["sid"].stringValue
                let account = cur[0]["account"].stringValue
                let passwd = cur[0]["passwd"].stringValue
                
                //save profile
                self.newProfile(account, passwd: passwd, sid: sid)
                //reload profile
                if self.loadUserInfo() {
                    println("mobile success, account: " + self.user[0].account)
                }
            }else {
                println("unknow res from mobile")
            }
        })
        
        socket.on("signup", callback: { (data, ack) -> Void in
            println("event signup")
            let cur = JSON(data!)
            let res = cur[0]["res"].stringValue
            if res == "0" {
                let sid = cur[0]["sid"].stringValue
                println("sign up success, sid: " + sid)
                //save user to core data
                self.userinfotemp.sid = sid
                self.updateProfile()
                //reload
                if self.loadUserInfo() {
                    println("signup success, account: " + self.user[0].account)
                }
                NSNotificationCenter.defaultCenter().postNotificationName("LoginSegue", object: nil)
                TWMessageBarManager.sharedInstance().showMessageWithTitle("註冊成功", description: "歡迎加入", type: TWMessageBarMessageType.Success)
            }else if res == "1" {
                TWMessageBarManager.sharedInstance().showMessageWithTitle("帳號已經有人使用", description: "請重新命名", type: TWMessageBarMessageType.Error)
            }else if res == "2" {
                TWMessageBarManager.sharedInstance().showMessageWithTitle("帳號或密碼格式不符", description: "帳號需大於9個字並小於20個字元, 密碼最少需要8個字元", type: TWMessageBarMessageType.Error)
            }else {
                println("unknow res from signup")
            }
            
        })
        
        socket.on("signin", callback: { (data, ack) -> Void in
            println("event signin")
            let cur = JSON(data!)
            let res = cur[0]["res"].stringValue
            if res == "0" {
                let sid = cur[0]["sid"].stringValue
                self.user[0].sid = sid
                TWMessageBarManager.sharedInstance().showMessageWithTitle("登入成功", description: "已上線", type: TWMessageBarMessageType.Success, duration: 0.5)
            }else {
                println("unknow res from signin")
            }
        })
        
        socket.on("signout", callback: { (data, ack) -> Void in
            println("event singout")
            let cur = JSON(data!)
            let res = cur[0]["res"].stringValue
            println(res)
            if res == "0" {
                TWMessageBarManager.sharedInstance().showMessageWithTitle("登出成功", description: "已離線", type: TWMessageBarMessageType.Success, duration: 0.5)
            }else {
                println("unknow res from signout")
            }
        })
        
        socket.on("message", callback: { (data, ack) -> Void in
            println("event message")
            let cur = JSON(data!)
            let res = cur[0]["res"].stringValue
            let sender = cur[0]["src"].stringValue
            let mediaId = cur[0]["mediaId"].stringValue
            if res == "0" {
                //send message success
                if mediaId != "" {
                    //posting media to server @ mediaId
                    //self.postImage(<#UIImage#>)
                }
            }else if sender != "" {
                //got message from others
                let text = cur[0]["text"].stringValue
                let time = self.stringToNSDate(cur[0]["time"].stringValue)
                if mediaId != "" {
                    //save to coreData
                    self.saveMessage(sender, text: nil, time: time, mediaId: mediaId)
                    //got image message
                    NSNotificationCenter.defaultCenter().postNotificationName("getImageMessage", object: nil, userInfo: ["account" : sender, "date" : time, "mediaId" : mediaId])
                }
                if text != "" {
                    //save to coreDate
                    self.saveMessage(sender, text: text, time: time, mediaId: nil)
                    //got text message notify
                    NSNotificationCenter.defaultCenter().postNotificationName("getMessage", object: nil, userInfo: ["account" : sender, "text" : text, "date" : time])
                }
            }else{
                println("unknow res from message")
            }
        })
        
        
        socket.connect()
        
    }
    
    //core data for userinfo
    //load user information from CoreData to Singleton
    func loadUserInfo() -> Bool {
        if user != [] {
            return true
        }
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let sortDescription = NSSortDescriptor(key: "account", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            var result = fetchResultController.performFetch(&e)
            user = fetchResultController.fetchedObjects as! [Userinfo]
            if result != true {
                println(e?.localizedDescription)
            }else {
                println("loading user...")
            }
            
        }
        if user != [] {
            println("have profile" + user[0].account!)
            return true
        }else {
            println("no user profile")
            //emit mobil for new account
            
            return false
        }
    }
    
    //add new user (for mobile)
    func newProfile(account: String, passwd: String, sid:String) {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            
            self.userinfo = NSEntityDescription.insertNewObjectForEntityForName("Userinformation",
                inManagedObjectContext: managedObjectContext) as! Userinfo
            self.userinfo.account = account
            self.userinfo.passwd = passwd
            self.userinfo.sid = sid
            
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                
            }else {
                println("new profile success")
            }
        }
    }
    //update exsit user
    func updateProfile() {
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let sortDescription = NSSortDescriptor(key: "account", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            var result = fetchResultController.performFetch(&e)
            user = fetchResultController.fetchedObjects as! [Userinfo]
            if result != true {
                println(e?.localizedDescription)
            }else {
                println("fetch user success")
            }
            if let account = self.userinfotemp.account {
                user[0].account = account
            }
            if let passwd = self.userinfotemp.passwd {
                user[0].passwd = passwd
            }
            if let picture = self.userinfotemp.picture {
                user[0].picture = picture
            }
            if let sid = self.userinfotemp.sid {
                user[0].sid = sid
            }
            
            if manageObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
            }else {
                println("update user success")
                //clear temp
                self.userinfotemp = userInfoTemp()
            }
        }
    }
    
    //coreData for messageinfo
    //text func
    func saveMessage(account: String, text:String?, time: NSDate, mediaId: String?) {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            //import message
            self.messageinformation = NSEntityDescription.insertNewObjectForEntityForName("Messageinfo", inManagedObjectContext: managedObjectContext) as! Messageinfo
            self.messageinformation.senderId = account
            self.messageinformation.senderDisplayName = account
            //self.messageinformation.roomID = roomid
            self.messageinformation.date = time
            self.messageinformation.text = text
            self.messageinformation.mediaId = mediaId
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
            }
        }
    }
    
    //transfer time to NSDate
    func stringToNSDate(string: String) -> NSDate {
        if string != "" {
            self.dateFormater.dateFormat = self.dateFormatterString
            return self.dateFormater.dateFromString(string)!
        }
        return NSDate()
    }
    //translate NSDate to Chinese String
    func NSDateToTWString(date: NSDate) -> String {
        self.dateFormater.dateFormat = self.dateFormatterTWString
        return self.dateFormater.stringFromDate(date)
    }
    
    
    //emit func
    //emit mobile for new account
    func mobile() {
        //wait server update
        
    }
    
    //emit sign up for regist account
    func signUp(account: String, passwd: String, picture: UIImage?, isPTT: Bool) {
        //perpare for user save in core data
        var accountmodify = account
        if isPTT {
            accountmodify += "@ptt.cc"
        }
        //input temp user, wait for save
        self.userinfotemp.account = accountmodify
        self.userinfotemp.passwd = passwd
        if let image = picture {
            self.userinfotemp.picture = UIImagePNGRepresentation(image)
        }
        let message = ["account": account, "passwd": passwd]
        self.socket.emit("signup", message)
        println("emit event signup: " + account)
    }
    
    //emit sign in for online server
    func signIn() {
        //double check userinfo
        if self.loadUserInfo() {
            let account = self.user[0].account
            let passwd = self.user[0].passwd
            let message = ["account": account, "passwd": passwd]
            self.socket.emit("signin", message)
            println("emit event signin: " + account)
        }else {
            println("尚未註冊帳號")
            self.mobile()
        }
    }
    
    //emit new message
    func emitMessage(receiver: String, text: String?, image: UIImage?) {
        if let media = image {
            //send image to server
            self.postImage(media)
        }
        if let mes = text {
            let message = ["dest": receiver, "text": mes]
            self.socket.emit("message", message)
            println("emit event message to: " + receiver)
        }
    }
    
    //image func
    func getImage(sender: String, mediaId: String) {
        //get image from server
        
        //save to coreData
    }
    
    func postImage(UIImage) {
        //send image to server
        
        
    }
    
    
    
}