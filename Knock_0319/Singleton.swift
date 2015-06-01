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
    
    
    func connectToServer() {
        socket.on("connect", callback: { (data, ack) -> Void in
            println("event socket connect")
            //load user
            if self.loadUserInfo() {
                //登入
                
            }else {
                //尚未申請帳號
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
            println(res)
            //wait server update
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
                self.newProfile()
                if self.loadUserInfo() {
                    //emit event signin
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
            if res == "0" {
                //send message success
                
            }else if sender != "" {
                //got message from others
                let mediaId = cur[0]["mediaId"].stringValue
                let text = cur[0]["text"].stringValue
                let time = self.stringToNSDate(cur[0]["time"].stringValue)
                if mediaId != "" {
                    //got image message
                    NSNotificationCenter.defaultCenter().postNotificationName("getImageMessage", object: nil)
                    self.getImage(sender, mediaId: mediaId)
                    
                }
                if text != "" {
                    //got text message
                    NSNotificationCenter.defaultCenter().postNotificationName("getMessage", object: nil, userInfo: ["account" : sender, "text" : text, "date" : time])
                    //save to coreDate
                    
                }
            }else{
                println("unknow res from message")
            }
        })
        
        
        socket.connect()
        
    }
    
    //core data func
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
            return false
        }
    }
    
    //add new user
    func newProfile() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            
            self.userinfo = NSEntityDescription.insertNewObjectForEntityForName("Userinformation",
                inManagedObjectContext: managedObjectContext) as! Userinfo
            self.userinfo.account = self.userinfotemp.account
            self.userinfo.passwd = self.userinfotemp.passwd
            self.userinfo.sid = self.userinfotemp.sid
            self.userinfo.picture = self.userinfotemp.picture
            
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
            }
        }
    }
    
    func signUp(account: String, passwd: String, picture: UIImage?, isPTT: Bool) {
        //perpare for user save in core data
        var accountmodify = account
        if isPTT {
            accountmodify += "@ptt.cc"
        }
        
        self.userinfotemp.account = accountmodify
        self.userinfotemp.passwd = passwd
        if let data = UIImagePNGRepresentation(picture) {
            self.userinfotemp.picture = data
        }
        let message = ["account": account, "passwd": passwd]
        self.socket.emit("signup", message)
        println("emit event: signup: " + account)
    }
    
    //image func
    func getImage(sender: String, mediaId: String) {
        //get image from server
        
        //save to coreData
    }
    
    func postImage(UIImage) {
        //send image to server
        
        
    }
    
    //text func
    func saveMessage(account: String, text:String, time: NSDate) {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            //import message
            self.messageinformation = NSEntityDescription.insertNewObjectForEntityForName("Messageinfo", inManagedObjectContext: managedObjectContext) as! Messageinfo
            self.messageinformation.senderId = account
            self.messageinformation.senderDisplayName = account
            //self.messageinformation.roomID = roomid
            self.messageinformation.date = time
            self.messageinformation.text = text
            
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
            }
        }
    }
    
    //transfer time to NSDate
    func stringToNSDate(string: String) -> NSDate {
        if string != "" {
            //transfer to nsdate
            
            
        }
        
        return NSDate()
    }
    
    
}