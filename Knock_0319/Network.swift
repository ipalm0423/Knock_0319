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


class SingletonC: NSObject, NSStreamDelegate {
    
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
    
    var readStream: NSInputStream?
    var writeStream: NSOutputStream?
    let serverAdress = "192.168.1.108"
    let serverPort = 8880
    var flag: String = "inputMessage"
    var networkQueue: dispatch_queue_t?
    
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
            self.closeSocketStreamSINGLE()
            
        default:
            self.closeSocketStreamSINGLE()
            
            
            
        }
    }
    
    func send(message:JSON){
        
        
        if  let write = writeStream?.hasSpaceAvailable { //stream ready for input
            //println("true hasSpaceAvailable")
            var data:NSData
            
            var thisMessage = message.stringValue
            
            
            data = thisMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            
            
            
            let bytesWritten = writeStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
            return
            
        }
        
        
    }
    
    func sendNewRoom() -> Bool {
        
        if writeStream!.hasSpaceAvailable {
            var message = "{\"method\": \"new\"}"
            var data = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var len1 = data!.length
            var len2: [UInt8] = intUsingEncodetoByte(len1)
            let headwrite = writeStream!.write(UnsafePointer<UInt8>(len2), maxLength: 2)
            let bytesWritten = writeStream!.write(UnsafePointer<UInt8>(data!.bytes), maxLength: data!.length)
            return true
            
            
            
        }else{
            return false
        }
        
        
        
    }
    
    
    func getServerData() -> NSString? {
        if readStream!.hasBytesAvailable {
            
            var buffer = [UInt8](count: 4096, repeatedValue: 0)
            
            while readStream!.hasBytesAvailable {
                var len = readStream!.read(&buffer, maxLength: buffer.count)
                if(len > 0){
                    var output = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding)
                    if (output != ""){
                        return output!
                    }
                }
            }
            
        }
        return nil
    }
    
    
    func intUsingEncodetoByte(number: Int) -> [UInt8] {
        let byte1 = UInt8((number / 256))
        let byte2 = UInt8(number)
        
        let byte: [UInt8] = [byte1, byte2]
        
        return byte
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
