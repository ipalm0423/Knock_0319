//
//  Boardinfo.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/6/6.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Boardinfo: NSManagedObject{
    @NSManaged var name:String!
    @NSManaged var subtitle:String?
    @NSManaged var id:String!
    //@NSManaged var roomID:String?
    //@NSManaged var time:NSDate?
    //@NSManaged var isTimeup:NSNumber?
    @NSManaged var picture:NSData?
    @NSManaged var section:String!
    
    
}

struct boardInfo {
    var name: String?
    var subtitle: String?
    var id: String?
    var picture: NSData?
    var section: String?
    
    init() {
        self.name = "八卦板"
        self.subtitle = "最新最夯的八卦"
        self.id = "123456"
        self.picture = UIImagePNGRepresentation(UIImage(named: "gossiping.png"))
        self.section = "清新健康"
    }
}