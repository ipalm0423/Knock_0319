//
//  title.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/11.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Titleinfo: NSManagedObject {
    @NSManaged var account:String!
    @NSManaged var push:String!
    @NSManaged var title:String!
    @NSManaged var icon:NSData?
    @NSManaged var picture:NSData?
    @NSManaged var time:NSDate!
    @NSManaged var board:String!
    @NSManaged var type:String?
    @NSManaged var articleID: NSValueTransformer?
    
}
struct titletest {
    var account: String!
    var title: String!
    var icon: NSData!
    var picture: NSData!
    var board: String!
    var pushNumber: String!
    var type: String!
    var time: NSDate!
    var isFavor: Bool!
    init() {
        self.account = "jo5566"
        self.title = "有生魚片煮了卻不好吃的八卦嗎？"
        self.type = "問卦"
        self.time = NSDate()
        self.board = "八卦版"
        self.pushNumber = "12"
        self.isFavor = false
        //self.icon = UIImagePNGRepresentation(UIImage(named: "head.jpg"))
        self.picture = UIImagePNGRepresentation(UIImage(named: "fish.jpg"))
    }
}