//
//  Singleton.swift
//  Knock_0319
//
//  Created by ipalm on 2015/3/22.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import Foundation
class Singleton {
    class var sharedInstance: Singleton {
        struct Static {
            static var readStream: Singleton?
            static var writeStream: Singleton?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.readStream = Singleton()
            Static.writeStream = Singleton()
        }
        
        return Static.readStream!
    }
}