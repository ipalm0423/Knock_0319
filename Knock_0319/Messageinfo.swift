

import UIKit
//
//  Message.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/20/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//


import Foundation
import CoreData

class Messageinfo: NSManagedObject{
    @NSManaged var text:String?
    @NSManaged var senderId:String!
    @NSManaged var senderDisplayName:String!
    @NSManaged var roomID:String?
    //@NSManaged var media:String?
    @NSManaged var date:NSDate!
    //@NSManaged var image:NSData?
    //@NSManaged var userID:String?
    
    
    
}



