

import UIKit
//
//  Message.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/20/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import Foundation

class Messageinfo : NSObject {
    var text_: String
    var senderId_: String
    var senderDisplayName_: String
    var date_: NSDate
    //var isMediaMessage_: Bool
    //var messageHash_: Int
    
    /*
    convenience init(text: String?, sender: String?, senderDisplayName: String?) {
        self.init(text: text, sender: sender, senderDisplayName: senderDisplayName)
    }*/
    
    init(text: String?, sender: String?, senderDisplayName: String?) {
        self.text_ = text!
        self.senderDisplayName_ = senderDisplayName!
        self.senderId_ = sender!
        self.date_ = NSDate()
        //self.isMediaMessage_ = false
        //self.messageHash_ = 1
        
    }
    
    func text() -> String! {
        return text_
    }
    
    func senderId() -> String! {
        return senderId_
    }
    
    func senderDisplayName() -> String! {
        return senderDisplayName_
    }
    
    func date() -> NSDate! {
        return date_
    }
    
    /*func isMediaMessage() -> Bool! {
        return isMediaMessage_
    }
    
    func messageHash() -> Int! {
        return messageHash_
    }*/
    
    
}