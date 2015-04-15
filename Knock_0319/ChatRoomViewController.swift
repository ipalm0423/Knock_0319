//
//  ChatRoomViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/4/1.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ChatRoomViewController: JSQMessagesViewController, NSFetchedResultsControllerDelegate {
    
    
    //var user: FAuthData?
    
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    
    var senderImageUrl: String!
    var batchMessages = true
    //var ref: Firebase!
    var bublefactory: JSQMessagesBubbleImageFactory = JSQMessagesBubbleImageFactory()
    var outputbuble: JSQMessagesBubbleImage!
    var inputbuble: JSQMessagesBubbleImage!
    
    var fetchResultController:NSFetchedResultsController!
    
    var testmessage: Messageinfo!
    var dateFormatter = NSDateFormatter()
    
    //chat information
    var roomID: String!
    var roomName: String!
    var userID = SingletonC.sharedInstance.user[0].uid
    var messageinformation: Messageinfo!
    //var unRead: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //inputToolbar.contentView.leftBarButtonItem = nil
        //automaticallyScrollsToMostRecentMessage = true
        //self.navigationController?.navigationBar.topItem?.title = "Kelly"
        self.title = self.roomName
        self.tabBarController?.tabBar.hidden = true
        
        self.senderDisplayName = "Jack"
        self.senderId = self.userID
        self.outputbuble = bublefactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        self.inputbuble = bublefactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        self.dateFormatter.dateFormat = "YYYY-MM-dd 'at' h:mm a"
        
        //self.senderDisplayName = (senderDisplayName != nil) ? senderDisplayName : "Anonymous"
        
        //load data from server
        /*let profileImageUrl = user?.providerData["cachedUserProfile"]?["profile_image_url_https"] as? NSString
        if let urlString = profileImageUrl {
            setupAvatarImage(sender, imageUrl: urlString, incoming: false)
            senderImageUrl = urlString
        } else {
            setupAvatarColor(sender, incoming: false)
            senderImageUrl = ""
        }
        */
        self.showLoadEarlierMessagesHeader = true
        //setup server load text
        self.setupPreviousMessage(10)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.collectionViewLayout.springinessEnabled = false
        
    }
    
    
    
    // ACTIONS
    /*
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }*/
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        if SingletonC.sharedInstance.checkSocketConnection(self) == false {
            return
        }
        
        let roomid = self.roomID
        
        if SingletonC.sharedInstance.sendText(roomid, text: text) {
            
            //wait build =>check server feeback
            
            //check ok, println
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            
            let temp = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
            //setupFirebase()
            
            self.messages.append(temp)
            
            self.finishSendingMessage()
            
            //add new queue
            //add observer & input sql
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
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
            })
            

        }
        
        
    }
    
 
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
        if SingletonC.sharedInstance.checkSocketConnection(self) == false {
            return
        }
        
        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()

        let mes1: JSQMessage = JSQMessage(senderId: "no2", senderDisplayName: "Kelly", date: NSDate(), text: "how are you?")
        
        self.messages.append(mes1)
        
        self.finishReceivingMessage()
        
        
    }

    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        let messageCount = messages.count + 10
        setupPreviousMessage(messageCount)
    }
    
    
    func setupPreviousMessage(number:Int) {
        //load SQL into messagetemp
        var messagesTemp: [Messageinfo] = []
        var fetchRequest = NSFetchRequest(entityName: "Messageinfo")
        let roomIDpredicate = NSPredicate(format: "roomID == %@", self.roomID)
        let timeSort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = roomIDpredicate
        fetchRequest.sortDescriptors = [timeSort]
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
                let message = JSQMessage(senderId: row.senderId, senderDisplayName: row.senderDisplayName, date: row.date, text: text)
                self.messages.append(message)
                self.finishReceivingMessageAnimated(false)
                
            }else {
                //media data
            }
            
        }
        
    }
    
    //input message
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    //setup buble
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.item]
        
        if message.senderDisplayName == self.senderDisplayName {
            return self.outputbuble
        }
        
        return self.inputbuble
    }
    
    //setup avatar image
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        if let avatar = avatars[message.senderDisplayName] {
            return avatar
        } else {
            //setupAvatarImage(message.senderDisplayName, imageUrl: nil, incoming: true)
            setupAvatarColor(message.senderDisplayName, incoming: true)
            return avatars[message.senderDisplayName]
        }
    }
    
    
    // add time string above cell
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let messageDate = messages[indexPath.item].date
        
        if indexPath.item > 0 {
            let previousmessageDate = messages[indexPath.item - 1].date
            let temp = previousmessageDate.dateByAddingTimeInterval(21600)
            if previousmessageDate.compare(messageDate) == NSComparisonResult.OrderedAscending {
                return CGFloat(0.0)
            }
        }
        
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        let str = dateFormatter.stringFromDate(message.date)
        return NSAttributedString(string: str)
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CGFloat(0.0)
    }
    
    // add sender name above buble
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        
        if message.senderDisplayName == self.senderDisplayName {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName)
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderDisplayName == self.senderDisplayName {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName == message.senderDisplayName {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    //data source
    //cell input include text color
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        

        if message.senderDisplayName == self.senderDisplayName {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        return cell
    }
    
    /*
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collect = collectionView as! JSQMessagesCollectionView
        let cell = super.collectionView(collect, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderDisplayName == self.senderDisplayName {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }*/
    
  
    
    
    
    
    
    
    
    
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    //var messagesRef: Firebase!
    
    func setupFirebase() {
        
        //load fake message
        //self.messages = [JSQMessage(senderId: "no1", senderDisplayName: "Jack", date: NSDate(timeIntervalSince1970: 60), text: "hello"), JSQMessage(senderId: "no2", senderDisplayName: "mary", date: NSDate(), text: "hi jack")]
        
        //let me1 = JSQMessage(senderId: "no2", displayName: "Kelly", text: "hi")
        let mes1: JSQMessage = JSQMessage(senderId: "no2", senderDisplayName: "Kelly", date: NSDate(), text: "how are you?")
        
        self.messages.append(mes1)
        

        /*
        // *** STEP 2: SETUP FIREBASE
        messagesRef = Firebase(url: "https://swift-chat.firebaseio.com/messages")
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        messagesRef.queryLimitedToNumberOfChildren(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let text = snapshot.value["text"] as? String
            let sender = snapshot.value["sender"] as? String
            let imageUrl = snapshot.value["imageUrl"] as? String
        
            let message = Message(text: text, sender: sender, imageUrl: imageUrl)
            self.messages.append(message)
            self.finishReceivingMessage()
        })*/
        
        //pull from coredata for 5 datas:
        /*
        var fetchRequest = NSFetchRequest(entityName: "Messageinfo")
        let sortDescription = NSSortDescriptor(key: "senderDisplayName_", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            var result = fetchResultController.performFetch(&e)
            messages = fetchResultController.fetchedObjects as [Messageinfo]
            if result != true {
                println(e?.localizedDescription)
            }
            
            //input message
            /*for ... {
                let temp = messages[num]
                let text: String? = messages.text_
                let sender: String? = messages.sender_
                let imageUrl: String? = messages.imageUrl_
                let messagelist = Messageinfo(text: text, sender: sender, imageUrl: imageUrl)
                self.messages.append(messagelist)
                self.finishReceivingMessage()
                
            }*/
        }*/

    }
    
    
    
    func sendMessage(text: String!, sender: String!) {
        // *** STEP 3: ADD A MESSAGE TO FIREBASE
        /*
        messagesRef.childByAutoId().setValue([
            "text":text,
            "sender":sender,
            "imageUrl":senderImageUrl
            ])*/
        
        //wait setup for singlton
        /*
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            
            self.testmessage = NSEntityDescription.insertNewObjectForEntityForName("Messageinfo",
                inManagedObjectContext: managedObjectContext) as Messageinfo
            self.testmessage.senderDisplayName_ = "me"
            self.testmessage.senderId_ = "no1"
            self.testmessage.date_ = NSDate()
            self.testmessage.text_ = "hello world"
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                
            }
        }*/
        
        

    }
   
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        //load picture for avator
        if let stringUrl = imageUrl {
            if let url = NSURL(string: stringUrl) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
                    avatars[name] = avatarImage
                    return
                }
            }
        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        //set defaul color
        setupAvatarColor(name, incoming: incoming)
        return
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
    
}