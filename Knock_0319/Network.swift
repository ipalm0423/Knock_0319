//
//  Network.swift
//  Knock_0319
//
//  Created by ipalm on 2015/3/21.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit


class Network: NSStream, NSStreamDelegate {
    

    var readStream: NSInputStream?
    var writeStream: NSOutputStream?
    let serverAdress = "192.168.1.108"
    let serverPort = 8880
    var flag: String = "inputMessage"
    
    
    //open socket
    func openSocketStream() {
        
        
        
        
        //put ip here
        NSStream.getStreamsToHostWithName(serverAdress, port: serverPort, inputStream: &readStream, outputStream: &writeStream)
        
        //Set read/write delegates
        readStream?.delegate = self
        writeStream?.delegate = self
        
        //Set SSL
        //readStream?.setProperty(NSStreamSocketSecurityLevelNegotiatedSSL, forKey: NSStreamSocketSecurityLevelKey)
        //writeStream?.setProperty(NSStreamSocketSecurityLevelNegotiatedSSL, forKey: NSStreamSocketSecurityLevelKey)
        
        //Set streams into run loops
        self.readStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.writeStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        //Open Streams
        self.readStream?.open()
        self.writeStream?.open()
        
        
            }
    
    //close socket
    func closeSocketStream() {
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
            self.closeSocketStream()
            
        default:
            self.closeSocketStream()
            
    

        }
    }
    
   
}
