//
//  textViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/4/16.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import CoreData

class textViewController: JSQMessagesViewController, NSFetchedResultsControllerDelegate {

    
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var fetchResultController:NSFetchedResultsController!
    var testmessage: Messageinfo!
    var dateFormatter = NSDateFormatter()
    
    //chat information
    var roomID: String!
    var userID = SingletonC.sharedInstance.user[0].uid
    var messageinformation: Messageinfo!
    //var unRead: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = self.userID
        self.senderDisplayName = "Jack"
        self.tabBarController?.tabBar.hidden = true
        self.dateFormatter.dateFormat = "YYYY-MM-dd 'at' h:mm a"
        self.showLoadEarlierMessagesHeader = true
        // Do any additional setup after loading the view, typically from a nib.
        
        //Load Message
        self.setupPreviousMessage(0, number: 5, limit: 20)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // table data delegate
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        var data = self.messages[indexPath.row]
        return data
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    //set buble image
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var data = self.messages[indexPath.row]
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }


    //setup avatar image
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        var message = messages[indexPath.item]
        if let avatar = avatars[message.senderDisplayName] {
            return avatar
        }else {
            //setupAvatarImage(message.senderDisplayName, imageUrl: nil, incoming: true)
            setupAvatarColor(message.senderDisplayName, incoming: true)
            return avatars[message.senderDisplayName]
        }
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = count(name)
        let initials : String? = name.substringToIndex(advance(senderDisplayName.startIndex, min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage
        return
    }

    
    //add time string
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        var message = messages[indexPath.item]
        var str = self.dateFormatter.stringFromDate(message.date)
        var ATTRString = NSAttributedString(string: str)
        return ATTRString
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        
        
        if indexPath.item > 0 {
            var messageDate = messages[indexPath.item].date
            var previousmessageDate = messages[indexPath.item - 1].date
            var temp = previousmessageDate.dateByAddingTimeInterval(21600)
            if previousmessageDate.compare(messageDate) == NSComparisonResult.OrderedAscending {
                return CGFloat(0.0)
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CGFloat(0.0)
    }
    
    
    // add sender name above buble
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        var message = messages[indexPath.item];
        
        // Sent by me, skip
        
        if message.senderId == self.senderId {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName)
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId == self.senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        var message = messages[indexPath.item]
        
        if message.senderId == self.senderId {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        var attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }

    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //setup function
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        if SingletonC.sharedInstance.checkSocketConnection(self) == false {
            return
        }
        var roomid = self.roomID
        
        
        if SingletonC.sharedInstance.sendText(roomid, text: text) {
            var newMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName,date: date, text: text)
            var message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: NSDate(), text: text)
            self.messages += [message]
            self.finishSendingMessage()
            
            
            
            //input core data
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
                
                self.messageinformation = NSEntityDescription.insertNewObjectForEntityForName("Messageinfo", inManagedObjectContext: managedObjectContext) as! Messageinfo
                self.messageinformation.senderId = senderId
                self.messageinformation.senderDisplayName = senderDisplayName
                self.messageinformation.roomID = roomid
                self.messageinformation.date = date
                self.messageinformation.text = text
                
                var e: NSError?
                if managedObjectContext.save(&e) != true {
                    println("insert error: \(e!.localizedDescription)")
                }
            }
        }
        
        
        
    }
    override func didPressAccessoryButton(sender: UIButton!) {
        var newMessage = JSQMessage(senderId: "no2", displayName: "kely", text: "text")
        var message = JSQMessage(senderId: "no2", senderDisplayName: "kely", date: NSDate(), text: "test")
        messages += [message]
        self.finishReceivingMessage()
        
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        var messageCount = self.messages.count
        
        setupPreviousMessage(messageCount, number: 5, limit: 20)
    }
    
    
    
    
    
    
    func setupPreviousMessage(offset:Int, number:Int, limit: Int) {
        //load SQL into messagetemp
        var messagesTemp: [Messageinfo] = []
        var fetchRequest = NSFetchRequest(entityName: "Messageinfo")
        let roomIDpredicate = NSPredicate(format: "roomID == %@", self.roomID)
        let timeSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.predicate = roomIDpredicate
        fetchRequest.sortDescriptors = [timeSort]
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchBatchSize = number
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            var result = fetchResultController.performFetch(&e)
            messagesTemp = fetchResultController.fetchedObjects as! [Messageinfo]
            if result != true {
                println(e?.localizedDescription)
            }
            
        }
        
        //input from temp to JSQMessage array & reload
        for row in messagesTemp {
            if let text = row.text {
                var message = JSQMessage(senderId: row.senderId, senderDisplayName: row.senderDisplayName, date: row.date, text: text)
                self.messages.insert(message, atIndex: 0)
                
            }else {
                //media data
            }
            
        }
        //reload
        self.finishReceivingMessageAnimated(false)
        
    }

}
