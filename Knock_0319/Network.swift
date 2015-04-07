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
    let serverAdress = "172.20.10.11"
    let serverPort = 8880
    var flag: String = "inputMessage"
    var networkQueue: dispatch_queue_t?
    
    //user parameter
    var uid: String = "1"
    var fetchResultController:NSFetchedResultsController!
    var user:[Userinfo] = []
    
    var chattext: String = ""
    
    
    
    
    //open socket
    func openSocketStreamSINGLE() {
        
        
        
        
        //put ip here
        NSStream.getStreamsToHostWithName(serverAdress, port: serverPort, inputStream: &readStream, outputStream: &writeStream)
        
        //Set read/write delegates
        readStream?.delegate = self
        writeStream?.delegate = self
        
        //Set SSL
        //readStream?.setProperty(NSStreamSocketSecurityLevelNegotiatedSSL, forKey: NSStreamSocketSecurityLevelKey)
        //writeStream?.setProperty(NSStreamSocketSecurityLevelNegotiatedSSL, forKey: NSStreamSocketSecurityLevelKey)
        
 
        //open a new thread
        networkQueue = dispatch_queue_create("com.knock.Queue", nil)
        
        dispatch_async(networkQueue, {
        //Set streams into run loops
        self.readStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.writeStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        //Open Streams
        self.readStream?.open()
        self.writeStream?.open()
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 15))
        
        })
        
    }
    
    //close socket
    func closeSocketStreamSINGLE() {
        readStream?.close()
        readStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        readStream?.delegate = nil
        
        writeStream?.close()
        writeStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        writeStream?.delegate = nil
        
        
    }
    
    //set socket event
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        switch eventCode {
        case NSStreamEvent.OpenCompleted:
            NSLog("open complete")
            
        case NSStreamEvent.HasBytesAvailable:
            //input stream
            if flag == "inputMessage" && aStream == readStream {
                
            }
            
        case NSStreamEvent.HasSpaceAvailable:
            //output stream
            if flag == "outputMessage" && aStream == writeStream {
                
                
                
            }
            
            
        case NSStreamEvent.ErrorOccurred:
            
            NSLog("ERROR: %", aStream.streamError!.code)
            
            
        case NSStreamEvent.EndEncountered:
            flag = "inputMessage"
            
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
        var message = "{\"method\": \"newroom\", \"id\": \(uid), \"roomname\": \"myFirstRoom\", \"alivetime\": 1000}"
        
        return send(message)
        
    }
    
    func joinRoom(roomNumber: String) -> Bool {
        
        let message = "{\"method\": \"join\", \"id\": \(uid), \"roomid\": \(roomNumber)}"
        
        
        return send(message)
        
    }
    
    func createID() -> Bool {
        
        var bool = false
        
        while !writeStream!.hasSpaceAvailable {
            
        }
        
        if writeStream!.hasSpaceAvailable {
            var message = "{\"method\": \"new\"}"
            var data = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var len1 = data!.length
            var len2: [UInt8] = intUsingEncodetoByte(len1)
            let headwrite = writeStream!.write(UnsafePointer<UInt8>(len2), maxLength: 2)
            let bytesWritten = writeStream!.write(UnsafePointer<UInt8>(data!.bytes), maxLength: data!.length)
            bool = true
            
        }
        
        return bool
        
    }
    
    //get data from inputstream and cut the data
    func getServerData() -> NSData? {
        while !readStream!.hasBytesAvailable{
            
        }
 
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
        let byte2 = UInt8(number)
        
        let byte: [UInt8] = [byte1, byte2]
        
        return byte
    }
    
    
    //load user information from CoreData to Singleton
    func loadUserInfo() {
        var fetchRequest = NSFetchRequest(entityName: "Userinformation")
        let sortDescription = NSSortDescriptor(key: "uid", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            var result = fetchResultController.performFetch(&e)
            user = fetchResultController.fetchedObjects as [Userinfo]
            let count = user.count - 1
            self.uid = user[count].uid
            if result != true {
                println(e?.localizedDescription)
            }
            
        }
    }

    
    
}

/*class Network: NSStream, NSStreamDelegate {
    

    var readStream: NSInputStream?
    var writeStream: NSOutputStream?
    let serverAdress = "192.168.1.108"
    let serverPort = 8880
    var flag: String = "inputMessage"
    
    

    //set socket event
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        switch eventCode {
        case NSStreamEvent.OpenCompleted:
            NSLog("open complete")
            
        case NSStreamEvent.HasBytesAvailable:
            //input stream
            if flag == "inputMessage" && aStream == readStream {
                
            }
            
        case NSStreamEvent.HasSpaceAvailable:
            //output stream
            if flag == "outputMessage" && aStream == writeStream {
                
                
                
            }
            
        
        case NSStreamEvent.ErrorOccurred:
            
            NSLog("ERROR: %", aStream.streamError!.code)
        
            
        case NSStreamEvent.EndEncountered:
            self.closeSocketStream()
            
        default:
            self.closeSocketStream()
            
    

        }
    }
    
   
}*/
