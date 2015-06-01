//
//  Userinfo.swift
//  Knock_0319
//
//  Created by ipalm on 2015/3/28.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import Foundation
import CoreData

class Userinfo: NSManagedObject{
    @NSManaged var account:String?
    @NSManaged var sid:String?
    @NSManaged var passwd:String?
    //@NSManaged var roomID:String?
    //@NSManaged var time:NSDate?
    //@NSManaged var isTimeup:NSNumber?
    @NSManaged var picture:NSData?
    //@NSManaged var userID:String?
    
    
}

struct userInfoTemp {
    var account: String?
    var passwd: String?
    var sid: String?
    var picture: NSData?
    
    init() {
        self.account = nil
        self.passwd = nil
        self.sid = nil
        self.picture = nil
    }
}