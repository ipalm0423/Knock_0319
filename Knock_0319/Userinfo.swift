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
    @NSManaged var account:String!
    @NSManaged var name:String?
    @NSManaged var sid:String?
    @NSManaged var passwd:String?
    //@NSManaged var roomID:String?
    //@NSManaged var time:NSDate?
    //@NSManaged var isTimeup:NSNumber?
    @NSManaged var picture:NSData?
    @NSManaged var email:String?
    //@NSManaged var userID:String?
    @NSManaged var isUser:NSNumber!
    @NSManaged var isRegistKnockUser:NSNumber?
    @NSManaged var isFollow:NSNumber?
    //summary
    @NSManaged var follower:NSNumber?
    @NSManaged var greenPush:NSNumber?
    @NSManaged var redPush:NSNumber?
    @NSManaged var totalTitle:NSNumber?
    
}

struct userInfoTemp {
    var account: String?
    var name: String?
    var passwd: String?
    var sid: String?
    var picture: NSData?
    var isUser: Bool?
    var isRegistKnockUser: Bool?
    var isFollow: Bool?
    var email: String?
    var follower: Int!
    var greenPush: Int!
    var redPush: Int!
    var totalTitle: Int!
    init() {
        self.account = nil
        self.passwd = nil
        self.sid = nil
        self.picture = nil
        self.email = nil
        self.isRegistKnockUser = nil
        self.isFollow = nil
        self.isUser = nil
        self.name = nil
        self.follower = 0
        self.greenPush = 0
        self.redPush = 0
        self.totalTitle = 0
    }
}