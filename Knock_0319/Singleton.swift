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
    
    //view parameter
    var isSimpleViewOpen = false
    
    
    
    //parameter
    
    
    //keyboard parameter
    var keyboardIsShow = false
    //user
    let UUID = UIDevice.currentDevice().identifierForVendor.UUIDString
    var userinfo: Userinfo!
    var userinfotemp = userInfoTemp()
    var userIsRegist = false
    //var getedUserID: Bool = false
    //var userPicture: UIImage?
    var fetchResultController:NSFetchedResultsController!
    var user:[Userinfo] = []
    var followers: [Userinfo] = []
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
        
        
        socket.on("signup", callback: { (data, ack) -> Void in
            println("event signup")
            let cur = JSON(data!)
            let res = cur[0]["res"].stringValue
            if res == "0" {
                let sid = cur[0]["sid"].string
                let account = cur[0]["account"].string
                let passwd = cur[0]["password"].string
                println("sign up success")
                //save user to core data
                self.userinfotemp.sid = sid
                self.userinfotemp.account = account
                self.userinfotemp.passwd = passwd
                if account == nil {
                    self.userinfotemp.isRegistKnockUser = true
                }else {
                    self.userinfotemp.isRegistKnockUser = false
                }
                
                self.updateProfile()
                //reload
                if self.loadUserInfo() {
                    if self.user[0].isRegistKnockUser!.boolValue == true {
                        NSNotificationCenter.defaultCenter().postNotificationName("LoginSegue", object: nil)
                        TWMessageBarManager.sharedInstance().showMessageWithTitle("註冊成功", description: "歡迎加入", type: TWMessageBarMessageType.Success)
                    }else {
                        TWMessageBarManager.sharedInstance().showMessageWithTitle("歡迎加入", description: "註冊帳號可以享有更多功能", type: TWMessageBarMessageType.Success)
                    }
                    
                }
                
                
            }else if res == "1" {
                TWMessageBarManager.sharedInstance().showMessageWithTitle("帳號已經有人使用", description: "請重新命名", type: TWMessageBarMessageType.Error)
            }else if res == "2" {
                TWMessageBarManager.sharedInstance().showMessageWithTitle("帳號或密碼格式不符", description: "帳號需大於9個字並小於20個字元, 密碼最少需要8個字元", type: TWMessageBarMessageType.Error)
            }else {
                println("unknow res from signup: " + res)
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
        
        socket.on("boardcast", callback: { (data, ack) -> Void in
            let cur = JSON(data!)
            let mes = cur[0]["boardcast"].stringValue
            if mes != "" {
                TWMessageBarManager.sharedInstance().showMessageWithTitle("重要資訊", description: mes, type: TWMessageBarMessageType.Info)
            }
        })
        
        
        socket.connect()
        
    }
    
    //core data for userinfo
    func userInfoToUserTemp(user: Userinfo?) -> userInfoTemp? {
        
        if let user = user {
            var usertemp = userInfoTemp()
            
            if let account = user.account {
                usertemp.account = account
            }
            if let name = user.name {
                usertemp.name = name
            }
            if let passwd = user.passwd {
                usertemp.passwd = passwd
            }
            if let picture = user.picture {
                usertemp.picture = picture
            }
            if let sid = user.sid {
                usertemp.sid = sid
            }
            if let email = user.email {
                usertemp.email = email
            }
            if let bool = user.isRegistKnockUser {
                usertemp.isRegistKnockUser = bool.boolValue
            }
            if let bool = user.isUser {
                usertemp.isUser = bool.boolValue
            }
            if let bool = user.isFollow {
                usertemp.isFollow = bool.boolValue
            }
            if let follower = user.follower {
                usertemp.follower = follower.integerValue
            }
            if let greenPush = user.greenPush {
                usertemp.greenPush = greenPush.integerValue
            }
            if let redPush = user.redPush {
                usertemp.redPush = redPush.integerValue
            }
            if let totalTitle = user.totalTitle {
                usertemp.totalTitle = totalTitle.integerValue
            }
            return usertemp
        }
        
        return nil
    }
    //load user information from CoreData to Singleton
    func loadUserInfo() -> Bool {
        if user != [] {
            return true
        }
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let sortDescription = NSSortDescriptor(key: "account", ascending: true)
        let isUserPredicate = NSPredicate(format: "isUser == %@", NSNumber(bool: true))
        fetchRequest.predicate = isUserPredicate
        fetchRequest.sortDescriptors = [sortDescription]
        fetchRequest.fetchBatchSize = 1
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
            println("user have profile: " + user[0].account!)
            return true
        }else {
            println("no user profile")
            return false
        }
    }
    
    
    //update exsit user
    func updateProfile() {
        if self.loadUserInfo() {
            //have profile already, update
            var fetchRequest = NSFetchRequest(entityName: "Userinformation")
            let isUserPredicate = NSPredicate(format: "isUser == %@", NSNumber(bool: true))
            let sortDescription = NSSortDescriptor(key: "account", ascending: true)
            fetchRequest.predicate = isUserPredicate
            fetchRequest.sortDescriptors = [sortDescription]
            fetchRequest.fetchBatchSize = 1
            if let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                fetchResultController.delegate = self
                var e:NSError?
                var result = fetchResultController.performFetch(&e)
                user = fetchResultController.fetchedObjects as! [Userinfo]
                if result != true {
                    println(e?.localizedDescription)
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
                if let email = self.userinfotemp.email {
                    user[0].email = email
                }
                if let bool = self.userinfotemp.isRegistKnockUser {
                    user[0].isRegistKnockUser = NSNumber(bool: bool)
                }
                
                user[0].isUser = NSNumber(bool: true)
                
                
                if manageObjectContext.save(&e) != true {
                    println("insert error: \(e!.localizedDescription)")
                    return
                }
                println("update user success, account: " + user[0].account)
                //clear temp
                self.userinfotemp = userInfoTemp()
            }
            
            
        }else {
            //no profile, new create
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                
                self.userinfo = NSEntityDescription.insertNewObjectForEntityForName("Userinformation",
                    inManagedObjectContext: managedObjectContext) as! Userinfo
                if let account = self.userinfotemp.account {
                    self.userinfo.account = account
                }
                if let passwd = self.userinfotemp.passwd {
                    self.userinfo.passwd = passwd
                }
                if let sid = self.userinfotemp.sid {
                    self.userinfo.sid = sid
                }
                if let picture = self.userinfotemp.picture {
                    self.userinfo.picture = picture
                }
                if let email = self.userinfotemp.email {
                    self.userinfo.email = email
                }
                if let bool = self.userinfotemp.isRegistKnockUser {
                    self.userinfo.isRegistKnockUser = NSNumber(bool: bool)
                }else {
                    self.userinfo.isRegistKnockUser = NSNumber(bool: false)
                }
                self.userinfo.isUser = NSNumber(bool: true)
                
                
                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("insert error: \(e!.localizedDescription)")
                    return
                }
                
                println("new create profile success, account: " + self.userinfo.account!)
                //clear temp
                self.userinfotemp = userInfoTemp()
            }
            
        }
        
    }
    
    //search follower
    func searchFollower(account: String) -> userInfoTemp? {
        //fetch request
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let accountPredicate = NSPredicate(format: "account == %@", account)
        var compoundPredicate = NSCompoundPredicate.andPredicateWithSubpredicates([accountPredicate])
        let sortDescription = NSSortDescriptor(key: "account", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescription]
        fetchRequest.fetchBatchSize = 1
        
        if let MOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: MOC, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultController.delegate = self
            var e: NSError?
            if !fetchResultController.performFetch(&e) {
                println(e?.localizedDescription)
            }
            let followers = fetchResultController.fetchedObjects as! [Userinfo]
            if let follower = followers.first {
                println("search follower " + account + " success, have one: " + account)
                return self.userInfoToUserTemp(follower)
            }else {
                println("search follower " + account + " success, but empty.")
                return nil
            }
        }
        println("search follower fail: " + account)
        return nil
    }
    
    //save follower
    func saveFollower(user: userInfoTemp) -> Userinfo? {
        //send to server
        
        
        //fetch request
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let isUserPredicate = NSPredicate(format: "isUser == %@", NSNumber(bool: false))
        let accountPredicate = NSPredicate(format: "account == %@", user.account!)
        var compoundPredicate = NSCompoundPredicate.andPredicateWithSubpredicates([isUserPredicate, accountPredicate])
        let sortDescription = NSSortDescriptor(key: "account", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescription]
        fetchRequest.fetchBatchSize = 1
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            //fetch user with account
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultController.delegate = self
            var e: NSError?
            var result = self.fetchResultController.performFetch(&e)
            self.followers = fetchResultController.fetchedObjects as! [Userinfo]
            if result != true {
                println(e?.localizedDescription)
            }
            
            //check if user exist
            if self.followers.count > 0 {
                //update it
                if let picture = user.picture {
                    self.followers[0].picture = picture
                }
                if let redPush = user.redPush {
                    self.followers[0].redPush = redPush
                }
                if let greenPush = user.greenPush {
                    self.followers[0].greenPush = greenPush
                }
                if let follower = user.follower {
                    self.followers[0].follower = follower
                }
                if let totalTitle = user.totalTitle {
                    self.followers[0].totalTitle = totalTitle
                }
                if let name = user.name {
                    self.followers[0].name = name
                }
                if let isRegistKnockUser = user.isRegistKnockUser {
                    self.followers[0].isRegistKnockUser = NSNumber(bool: isRegistKnockUser)
                }
                self.followers[0].isFollow = NSNumber(bool: true)
                
                if managedObjectContext.save(&e) != true {
                    println("update follower error: \(e!.localizedDescription)")
                    return nil
                }
                println("update follower success, account: " + self.followers[0].account)
                return self.followers[0]
            }else {
                //save user
                self.userinfo = NSEntityDescription.insertNewObjectForEntityForName("Userinformation",
                    inManagedObjectContext: managedObjectContext) as! Userinfo
                self.userinfo.account = user.account
                self.userinfo.redPush = user.redPush
                self.userinfo.greenPush = user.greenPush
                self.userinfo.follower = user.follower
                self.userinfo.totalTitle = user.totalTitle
                self.userinfo.isRegistKnockUser = user.isRegistKnockUser
                self.userinfo.isUser = NSNumber(bool: false)
                self.userinfo.name = user.name
                self.userinfo.picture = user.picture
                self.userinfo.isFollow = NSNumber(bool: true)
                
                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("save follower error: \(e!.localizedDescription)")
                    return nil
                }
                println("add follower success, account: " + self.userinfo.account!)
                return self.userinfo
            }
        }
        println("core data error: can't read")
        return nil
    }
    
    //delete follower
    func deleteFollower(account: String) -> Bool {
        //send to server
        
        
        //fetch request
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let isUserPredicate = NSPredicate(format: "isUser == %@", NSNumber(bool: false))
        let accountPredicate = NSPredicate(format: "account == %@", account)
        var compoundPredicate = NSCompoundPredicate.andPredicateWithSubpredicates([isUserPredicate, accountPredicate])
        let sortDescription = NSSortDescriptor(key: "account", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescription]
        
        if let MOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: MOC, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultController.delegate = self
            var e: NSError?
            if !self.fetchResultController.performFetch(&e) {
                println(e?.localizedDescription)
            }
            
            let followers = self.fetchResultController.fetchedObjects as! [Userinfo]
            
            /*
            if let follower = followers.first {
                MOC.deleteObject(follower)
            }*/
            if let follower = followers.first {
                follower.isFollow = NSNumber(bool: false)
            }
            
            if MOC.save(&e) != true {
                println("delete follower error: \(e!.localizedDescription)")
                return false
            }
            println("unfollower to : " + account)
            return true
        }
        return false
    }
    
    func deleteUnFollower() -> Bool {
        //fetch request
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let isUserPredicate = NSPredicate(format: "isUser == %@", NSNumber(bool: false))
        let accountPredicate = NSPredicate(format: "isFollow == %@", NSNumber(bool: false))
        var compoundPredicate = NSCompoundPredicate.andPredicateWithSubpredicates([isUserPredicate, accountPredicate])
        let sortDescription = NSSortDescriptor(key: "account", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescription]
        
        if let MOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: MOC, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultController.delegate = self
            var e: NSError?
            if !self.fetchResultController.performFetch(&e) {
                println(e?.localizedDescription)
            }
            
            let followers = self.fetchResultController.fetchedObjects as! [Userinfo]
            var followersName = ""
            for follower in followers {
                MOC.deleteObject(follower)
                followersName += follower.account + ", "
            }
            
            if MOC.save(&e) != true {
                println("delete follower error: \(e!.localizedDescription)")
                return false
            }
            println("delete follower success: " + followersName)
            return true
        }
        return false
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
        println("emit mobile")
        self.socket.emit("signup", [])
        
    }
    
    //emit sign up for regist account
    func signUp(account: String, passwd: String, picture: UIImage?, isPTT: Bool) {
        //wait setup email
        
        
        
        //input temp user, wait for save
        self.userinfotemp.account = account
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
    
    
    
    
    
    //view func
    //jump up profile view
    func ShowProfileView(account: String) {
        println("show simple profile: " + account)
        if let window = UIApplication.sharedApplication().keyWindow {
            if let rootVC = window.rootViewController {
                let profileVC = rootVC.storyboard?.instantiateViewControllerWithIdentifier("SimpleProfileViewController") as! SimpleProfileViewController
                let center = rootVC.view.center
                profileVC.view.frame = CGRect(x: (center.x - 100), y: -300 , width: 200, height: 300)
                //setup parameter
                profileVC.account = account
                
                
                rootVC.addChildViewController(profileVC)
                rootVC.view.addSubview(profileVC.view)
                profileVC.didMoveToParentViewController(rootVC)
                
                //query user from server
                
                
                
                //test
                
                var usertest = userInfoTemp()
                usertest.account = account
                usertest.name = "五六無敵"
                usertest.redPush = 100
                usertest.greenPush = 30
                usertest.follower = 5
                usertest.totalTitle = 24
                profileVC.user = usertest
                
                
                //animate
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    profileVC.view.frame.offset(dx: 0, dy: 150 + center.y)
                    }, completion: nil)
                println("open simple profile: " + account)
            }
        }
    }
    
    //jump to log in view
    func ShowLoginView(isRegist: Bool) {
        if let window = UIApplication.sharedApplication().keyWindow {
            let frame = window.frame
            if let rootVC = window.rootViewController {
                let loginVC = rootVC.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                loginVC.view.frame = CGRect(x: 40, y: -frame.height, width: frame.width - 80, height: frame.height - 80)
                loginVC.view.layer.cornerRadius = 5
                loginVC.view.clipsToBounds = true
                
                //set up
                loginVC.isRegist = isRegist
                rootVC.addChildViewController(loginVC)
                rootVC.view.addSubview(loginVC.view)
                loginVC.didMoveToParentViewController(rootVC)
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    loginVC.view.frame.offset(dx: 0.0, dy: frame.height + 40)
                    }, completion: nil)
                println("open log in view")
            }
            
        }
    }
    
}