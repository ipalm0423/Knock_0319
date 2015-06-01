//
//  textViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/4/16.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import CoreData
import JSQMessagesViewController

class textViewController: JSQMessagesViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var fetchResultController:NSFetchedResultsController!
    var testmessage: Messageinfo!
    var dateFormatter = NSDateFormatter()
    var mediaPicture: UIImage?
    

    //chat information
    var roomID: String!
    var roomName: String!
    //var roomPicture: UIImage?
    var messageinformation: Messageinfo!
    //var unRead: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = SingletonC.sharedInstance.user[0].account
        self.senderDisplayName = "Jack"
        self.tabBarController?.tabBar.hidden = true
        self.dateFormatter.dateFormat = "YYYY-MM-dd 'at' h:mm a"
        self.showLoadEarlierMessagesHeader = true
        // Do any additional setup after loading the view, typically from a nib.
        SingletonC.sharedInstance.openedRoomID = self.roomID
        if self.roomName == nil {
            //load room name
            self.setupRoomName(self.roomID)
        }else {
            self.title = self.roomName
            
        }
        //Load Message
        self.setupPreviousMessage(0, number: 5, limit: 20)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //setup message in-room notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "GetedNewMessage:", name: "getMessage", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "remoteNotificationGotMessage:", name: "NotificationNewMessage", object: nil)
        
        
        var tapgesture = UITapGestureRecognizer(target: self, action: "returnKeyBoard:")
        tapgesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapgesture)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "getMessage", object: nil)
        SingletonC.sharedInstance.openedRoomID = nil
    }
    /*
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "GetedNewMessage:", name: "getMessage", object: nil)
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.messages = []
    }

    
    //setup keyboard
    func returnKeyBoard(sender: UITapGestureRecognizer) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("hideKeyBoard", object: nil)
        
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
        /*if message.senderId == self.senderId {
            return nil
        }*/
        if let avatar = avatars[message.senderId] {
            return avatar
        }else {
            //load picture from internet
            //setupAvatarImage(message.senderDisplayName, imageUrl: nil, incoming: true)
            
            //setup with colors
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
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(12)), diameter: diameter)
        
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
        if message.media == nil {
            if message.senderId == self.senderId {
                cell.textView.textColor = UIColor.blackColor()
            } else {
                cell.textView.textColor = UIColor.whiteColor()
            }
            var attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
            cell.textView.linkTextAttributes = attributes
            

        }

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
    //select row
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        println("test1")
        NSNotificationCenter.defaultCenter().postNotificationName("hideKeyBoard", object: nil)
    }
    
    
    //setup message function
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        if !SingletonC.sharedInstance.checkSocketConnectionToOpen()  {
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        mediaPicture = info[UIImagePickerControllerOriginalImage] as? UIImage
        mediaPicture?.resizingMode
        var jsqpicture = JSQPhotoMediaItem(image: self.mediaPicture)
        var message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: jsqpicture)
        self.messages += [message]
        self.finishReceivingMessage()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func didPressAccessoryButton(sender: UIButton!) {
        let sendMedia = UIAlertController(title: nil, message: "傳送照片", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let usePhoto = UIAlertAction(title: "相片集", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
                imagePicker.delegate = self
                
            }
        }
        let useCamera = UIAlertAction(title: "照相", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
                imagePicker.delegate = self
            }
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        sendMedia.addAction(usePhoto)
        sendMedia.addAction(useCamera)
        sendMedia.addAction(cancel)
        self.presentViewController(sendMedia, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        var messageCount = self.messages.count
        
        setupPreviousMessage(messageCount, number: 5, limit: 20)
    }
    
    func GetedNewMessage(notify: NSNotification) {
        
        if let userinfo = notify.userInfo as? Dictionary<String,AnyObject> {
            //check roomid
            if userinfo["roomid"] as! String == self.roomID {
                //check media
                if userinfo["type"] as! String == "text" {
                    let uid = userinfo["uid"] as! String
                    let displayName = userinfo["displayName"] as! String
                    let text = userinfo["text"] as! String
                    let date = userinfo["date"] as! NSDate
                    var message = JSQMessage(senderId: uid, senderDisplayName: displayName, date: date, text: text)
                    self.messages += [message]
                    self.finishReceivingMessage()
                    return
                }else {
                    //media data
                    
                    
                    
                    
                    
                    return
                }
            }
            return
            
        }
        return

    }
    
    func setupRoomName(roomid: String) {
        var roomTemp: [Roominfo] = []
        var fetchRequest = NSFetchRequest(entityName: "Roominfo")
        let roomIDpredicate = NSPredicate(format: "roomID == %@", roomid)
        let roomidsort = NSSortDescriptor(key: "roomID", ascending: true)
        fetchRequest.predicate = roomIDpredicate
        fetchRequest.sortDescriptors = [roomidsort]
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            var result = fetchResultController.performFetch(&e)
            roomTemp = fetchResultController.fetchedObjects as! Array<Roominfo>
            //setup
            self.roomName = roomTemp[0].roomName
            self.title = roomTemp[0].roomName
            if result != true {
                println(e?.localizedDescription)
            }
            
        }
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
