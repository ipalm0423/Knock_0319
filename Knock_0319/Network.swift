//
//  Network.swift
//  Knock_0319
//
//  Created by ipalm on 2015/3/21.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import CoreFoundation
import CoreData


class SingletonC: NSObject, NSStreamDelegate, NSFetchedResultsControllerDelegate {
    
    class var sharedInstance: SingletonC {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: SingletonC? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SingletonC()
        }
        return Static.instance!
    }
    
    
    //socket parameter
    var readStream: NSInputStream?
    var writeStream: NSOutputStream?
    let serverAdress = "122.116.90.83"
    let serverPort = 30000
    var flag: String = "inputMessage"
    var networkQueue: dispatch_queue_t?
    
    //user parameter
    var userInformation: Userinfo!
    var getedUserID: Bool = false
    var userPicture: UIImage?
    var fetchResultController:NSFetchedResultsController!
    var user:[Userinfo] = []
    
    var chattext: String = ""
    
    //room parameter
    var roominformation: Roominfo!
    var roomPicture: UIImage?
    var roomNewID: String?
    var roomNewName: String?
    var getedRoomID: Bool = false
    var openedRoomID: String?
    
    
    //UI notification
    var localNotification: UILocalNotification = UILocalNotification()
    
    //message parameter
    var messageinformation: Messageinfo!
    //check internet
    func checkSocketConnectionToOpen() -> Bool {
        if (SingletonC.sharedInstance.readStream?.streamStatus != NSStreamStatus.Open) && (SingletonC.sharedInstance.readStream?.streamStatus != NSStreamStatus.Opening) {
            //try reconnection
            /*if readStream != nil {
                closeSocketStreamSINGLE()
            }*/
            
            //問題描述
            if let erro = self.readStream?.streamError?.localizedDescription {
                dispatch_async(dispatch_get_main_queue(), {
                    var alert:UIAlertView = UIAlertView(title: "Oops", message: "無法連線網路，問題:" + erro + ", 重新連線？", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                })
                
            }
            
            
            if SingletonC.sharedInstance.openSocketStreamSINGLE() {
                SingletonC.sharedInstance.checkUserIDandOnline()
            }
            
            
            
            return false
        }
        
       return true

    }
    
    //load user info and send "online" to server
    func checkUserIDandOnline() -> Bool {
        
        if loadUserInfo() {
            //有帳號
            if onlineID() {
                return true
            }else {
                dispatch_async(dispatch_get_main_queue(), {
                    var alert:UIAlertView = UIAlertView(title: "Oops", message: "無法登入帳號", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                })
                
                return false
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), {
                var alert:UIAlertView = UIAlertView(title: "Oops", message: "尚未建立帳號", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            })
            
            return false
        }
    }
    
    

    //open socket
    func openSocketStreamSINGLE() -> Bool{
        
        //put ip here
        NSStream.getStreamsToHostWithName(self.serverAdress, port: self.serverPort, inputStream: &self.readStream, outputStream: &self.writeStream)
        
        //Set read/write delegates
        self.readStream?.delegate = self
        self.writeStream?.delegate = self
        
        //Set SSL
        //readStream?.setProperty(NSStreamSocketSecurityLevelNegotiatedSSL, forKey: NSStreamSocketSecurityLevelKey)
        //writeStream?.setProperty(NSStreamSocketSecurityLevelNegotiatedSSL, forKey: NSStreamSocketSecurityLevelKey)
        
 
        //open a new thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //Set streams into run loops
            self.readStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            self.writeStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            
            //Open Streams
            self.readStream?.open()
            self.writeStream?.open()
            NSRunLoop.currentRunLoop().run()
        })
        return true
        
    }
    
    //close socket
    func closeSocketStreamSINGLE() {
        
        readStream?.close()
        readStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        readStream?.delegate = nil
        readStream = nil
        writeStream?.close()
        writeStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        writeStream?.delegate = nil
        writeStream = nil
        
    }
    
    //set socket event
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        switch eventCode {
        case NSStreamEvent.OpenCompleted:
            NSLog("open complete")
            
        case NSStreamEvent.HasBytesAvailable:
            //input stream
            if aStream == readStream {
                // load data
                if let inputdata = getServerData() {
                
                    let json = JSON(data: inputdata)
                    let method = json["method"].stringValue
                    let status = json["status"].stringValue
                    
                    //base on method
                    if method == "chat" {
                        if status == "getok" {
                            //讀取未讀訊息
                            let roomid = json["roomid"].stringValue
                            let uid = json["uid"].stringValue
                            let type = json["mtype"].stringValue
                            //let date = json["time"].stringValue
 
                            //send
                            if type == "text" {
                                //text data
                                let content = json["content"].stringValue
                                //input coredata
                                if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                                    //import message
                                    self.messageinformation = NSEntityDescription.insertNewObjectForEntityForName("Messageinfo", inManagedObjectContext: managedObjectContext) as! Messageinfo
                                    self.messageinformation.senderId = uid
                                    self.messageinformation.senderDisplayName = "Anonymours"
                                    self.messageinformation.roomID = roomid
                                    self.messageinformation.date = NSDate()
                                    self.messageinformation.text = content

                                    var e: NSError?
                                    if managedObjectContext.save(&e) != true {
                                        println("insert error: \(e!.localizedDescription)")
                                    }
                                    //import unRead count
                                    if roomid != self.openedRoomID {
                                        var roomFetchRequest = NSFetchRequest(entityName: "Roominfo")
                                        roomFetchRequest.predicate = NSPredicate(format: "roomID = %@", roomid)
                                        var roominfo: Array<Roominfo> = []
                                        roominfo = managedObjectContext.executeFetchRequest(roomFetchRequest, error: nil) as! Array<Roominfo>
                                        var unread = roominfo[0].unRead
                                        roominfo[0].unRead = NSNumber(integer: (unread.integerValue + 1))
                                        if managedObjectContext.save(&e) != true {
                                            println("insert error: \(e!.localizedDescription)")
                                        }
                                        //local notification
                                        TWMessageBarManager.sharedInstance().showMessageWithTitle(roomid, description: content, type: TWMessageBarMessageType.Info)
                                        
                                    }
                                    
                                }
                                
                                
                                //notify
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                        NSNotificationCenter.defaultCenter().postNotificationName("NotificationGetedMessage", object: nil, userInfo: ["roomid" : roomid, "type" : "text", "uid" : uid,"displayName" : "Anonymour", "text" : content, "date" : NSDate()])
                                })
                                
                            }else {
                                //media data
                                
                                //self.roominformation.image = UIImagePNGRepresentation(roomPicture!)
                                //restaurant.isVisited = NSNumber.convertFromBooleanLiteral(isVisited)
                            }
                        }else if status == "sendok" {
                            //傳送訊息ok
                            
                            //post observer
                            
                        }
                    }else if method == "newroom" {
                        let roomID = json["roomid"].stringValue
                        let roomName = self.roomNewName!
                        //let roomName = json["roomname"].stringValue
                        self.roomNewID = roomID
                        
                    
                        //input coreData
                        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                    
                            self.roominformation = NSEntityDescription.insertNewObjectForEntityForName("Roominfo", inManagedObjectContext: managedObjectContext) as! Roominfo
                            self.roominformation.roomName = roomName
                            self.roominformation.roomID = roomID
                            self.roominformation.image = UIImagePNGRepresentation(roomPicture!)
                            self.roominformation.unRead = 0
                            //roominformation.isTimeup = 0
                            //            restaurant.isVisited = NSNumber.convertFromBooleanLiteral(isVisited)
                            var e: NSError?
                            if managedObjectContext.save(&e) != true {
                                println("insert error: \(e!.localizedDescription)")
                            }
                        }
                        self.getedRoomID = true
                        
                    }else if method == "new" {
                        let userID = json["uid"].stringValue
                        let serverID = json["sid"].stringValue
     
                        //input core data
                        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                            
                            self.userInformation = NSEntityDescription.insertNewObjectForEntityForName("Userinformation",
                                inManagedObjectContext: managedObjectContext) as! Userinfo
                            self.userInformation.uid = userID
                            self.userInformation.sid = serverID
                            self.userInformation.picture = UIImagePNGRepresentation(userPicture!)
                            //roominformation.isTimeup = 0
                            //            restaurant.isVisited = NSNumber.convertFromBooleanLiteral(isVisited)
                            var e: NSError?
                            if managedObjectContext.save(&e) != true {
                                println("insert error: \(e!.localizedDescription)")
                                
                            }
                        }
                        loadUserInfoWithAlert()
                        getedUserID = true

                    }else if method == "join" {
                        let roomID = json["roomid"].stringValue
                        let roomName = json["roomname"].stringValue
                        self.roomNewID = roomID
                        self.roomNewName = roomName
                        
                        
                        //input coreData
                        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                            
                            self.roominformation = NSEntityDescription.insertNewObjectForEntityForName("Roominfo", inManagedObjectContext: managedObjectContext) as! Roominfo
                            self.roominformation.roomName = roomName
                            self.roominformation.roomID = roomID
                            if let picture = self.roomPicture {
                                self.roominformation.image = UIImagePNGRepresentation(picture)
                            }else {
                                self.roominformation.image = nil
                            }
                            self.roominformation.unRead = 0
                            //roominformation.isTimeup = 0
                            //            restaurant.isVisited = NSNumber.convertFromBooleanLiteral(isVisited)
                            var e: NSError?
                            if managedObjectContext.save(&e) != true {
                                println("insert error: \(e!.localizedDescription)")
                            }
                        }
                        self.getedRoomID = true
                    }
                }
                
            }
            
        case NSStreamEvent.HasSpaceAvailable:
            //output stream
            if flag == "outputMessage" && aStream == writeStream {
                
                
                
            }
            
            
        case NSStreamEvent.ErrorOccurred:
            
            NSLog("ERROR: %", aStream.streamError!.code)
            
            
        case NSStreamEvent.EndEncountered:
            NSLog("ERROR: %", "NSStreamEndEncounter")
            
        default:
            flag = "inputMessage"
            
            
            
        }
    }
    
    func send(message:NSString) -> Bool {
        
        var bool = false

        while !writeStream!.hasSpaceAvailable {
            
        }
        
        if writeStream!.hasSpaceAvailable {
            
            var data = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var len1 = data!.length
            var len2: [UInt8] = intUsingEncodetoByte(len1)
            let headwrite = writeStream!.write(UnsafePointer<UInt8>(len2), maxLength: 2)
            let bytesWritten = writeStream!.write(UnsafePointer<UInt8>(data!.bytes), maxLength: data!.length)
            bool = true
        }
        return bool
        
    }
    
    func createNewRoom(roomName: String) -> Bool {
        //待修改房間名稱
        let uid = user[0].uid
        var message = "{\"method\": \"newroom\", \"uid\": \(uid), \"roomname\": \"myFirstRoom\", \"alivetime\": 1000}"
        
        return send(message)
        
    }
    
    func joinRoom(roomNumber: String) -> Bool {
        let uid = user[0].uid
        let message = "{\"method\": \"join\", \"uid\": \(uid), \"roomid\": \(roomNumber)}"
        
        return send(message)
        
    }
    
    func createID() -> Bool {
        
        
        let message = "{\"method\": \"new\"}"
        return send(message)
        
    }
    
    func onlineID() -> Bool {
        let uid = user[0].uid
        let message = "{\"method\": \"online\", \"uid\": \(uid)}"
        return send(message)
    }
    
    func sendText(roomID:String, text: String) -> Bool {
        let uid = user[0].uid
        let message = "{\"method\": \"chat\", \"roomid\": \(roomID), \"uid\": \(uid), \"mtype\": \"text\", \"content\": \"\(text)\"}"
        
        return send(message)
        
    }
    
    func sendToken(token: NSData) -> Bool {
        let uid = user[0].uid
        let toke = token
        let message = "{\"method\": \"newtoken\", \"uid\": \(uid), \"token\": \(toke)}"
        return send(message)
    }
    
    //get data from inputstream and cut the data
    func getServerData() -> NSData? {
        
 
            var buffer = [UInt8](count: 65536, repeatedValue: 0)
            
            while readStream!.hasBytesAvailable {
                var len = readStream!.read(&buffer, maxLength: buffer.count)
                if(len > 0){
                    let data = NSData(bytes: &buffer, length: buffer.count)
                    
                    if (data != ""){

                        //head number
                        var headbyte: [UInt8] = [0x00, 0x00]
                        data.getBytes(&headbyte, range: NSMakeRange(0, 2))
                        
                        //head.getBytes(&headbyte)
                        var length: Int = 0
                        var p0 = Int(headbyte[0]), p1 = Int(headbyte[1])
                        if p0 != 0 {
                            length = p0 * p1
                        }else{
                            length = p1
                        }

                        //cut byte
                        let cutdata = data.subdataWithRange(NSMakeRange(2, length))

                        return cutdata
                    }
                }
            }
            
        
        return nil
    }
    
    //socket protocol
    func intUsingEncodetoByte(number: Int) -> [UInt8] {
        let byte1 = UInt8((number / 256))
        let byte2 = UInt8(number % 256)
        
        let byte: [UInt8] = [byte1, byte2]
        
        return byte
    }
    
    
    //load user information from CoreData to Singleton
    func loadUserInfo() -> Bool {
        if user != [] {
            return true
        }
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let sortDescription = NSSortDescriptor(key: "uid", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            var result = fetchResultController.performFetch(&e)
            user = fetchResultController.fetchedObjects as! [Userinfo]
            if result != true {
                println(e?.localizedDescription)
            }
            
        }
        if user != [] {
            return true
        }else {
            
            return false
        }
        
    }
    func loadUserInfoWithAlert() -> Bool{
        if self.loadUserInfo() {
            return true
        }else {
            dispatch_async(dispatch_get_main_queue(), {
                var alert:UIAlertView = UIAlertView(title: "Oops", message: "尚未建立帳號", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            })
            return false
        }
    }
    
    
    
    
    func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return RBResizeImage(RBSquareImage(image), targetSize: size)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight - edge) / 2.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge)
        
        var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)!
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    
}

