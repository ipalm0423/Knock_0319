//
//  Articleinfo.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/24.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import Foundation
import CoreData

class Articleinfo: NSManagedObject {
    @NSManaged var id:String!
    @NSManaged var json:String!
    /*
    @NSManaged var icon:NSData?
    @NSManaged var picture:NSData?
    @NSManaged var time:NSDate!
    @NSManaged var board:String!
    @NSManaged var type:String?
    */
}