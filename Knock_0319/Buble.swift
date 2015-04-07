//
//  Buble.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/4/7.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import Foundation


class Buble {
    
    
    let factory: JSQMessagesBubbleImageFactory
    //let factory2: JSQMessagesBubbleImageFactory
    var outbuble: JSQMessagesBubbleImage
    var incbuble: JSQMessagesBubbleImage
    init() {
        factory = JSQMessagesBubbleImageFactory()
        //factory2 = JSQMessagesBubbleImageFactory()
        self.outbuble = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        self.incbuble = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
}