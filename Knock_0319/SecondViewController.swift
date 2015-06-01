//
//  SecondViewController.swift
//  Knock_0319
//
//  Created by ipalm on 2015/3/20.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import CoreData
import CoreFoundation
import MBProgressHUD



class SecondViewController: UIViewController, NSStreamDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var buttonJoinRoom: UIButton!

    @IBOutlet weak var buttonCreateRoom: UIButton!
    
    @IBOutlet weak var editRoomName: UITextField!
    
    @IBOutlet weak var addImage: UIImageView!

    
    var roominformation: Roominfo!
    var userInformation: Userinfo!
    
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var errorField = ""
    
    
    //edit Box return keyboard
    @IBAction func textFieldRetur(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func closeKeyboard(sender: AnyObject) {
        editRoomName.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //disable button
        self.buttonJoinRoom.enabled = false
        self.buttonCreateRoom.enabled = false
        self.editRoomName.clearButtonMode = UITextFieldViewMode.WhileEditing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clearButton:", name: "CreateRoom", object: nil)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        

        }
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "CreateRoom", object: nil)
    }
    
    //button enable by edit Box not empty
    @IBAction func editTextChanged(sender: AnyObject) {
        if editRoomName.text != "" {
            self.buttonCreateRoom.enabled = true
            self.buttonJoinRoom.enabled = true
        }else {
            self.buttonCreateRoom.enabled = false
            self.buttonJoinRoom.enabled = false
        }

    }
    @IBAction func addPicture(sender: AnyObject) {
        let takePicture = UIAlertController(title: nil, message: "新增照片", preferredStyle: UIAlertControllerStyle.ActionSheet)
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
        
        takePicture.addAction(usePhoto)
        takePicture.addAction(useCamera)
        takePicture.addAction(cancel)
        self.presentViewController(takePicture, animated: true, completion: nil)
        
        
        
        //.Photolibrary or .Camera
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        addImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        addImage.image?.resizingMode
        addImage.contentMode = UIViewContentMode.ScaleAspectFill
        addImage.clipsToBounds = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
    }
    @IBAction func createRoom(sender: UIButton) {
        // Form violation reminder
        
        //check network
        if !SingletonC.sharedInstance.checkSocketConnectionToOpen() {
            return
        }
        //check account
        if !SingletonC.sharedInstance.loadUserInfoWithAlert() {
            return
        }
        
        let roomNametemp = editRoomName.text
        // setup user picture
        SingletonC.sharedInstance.roomPicture = SingletonC.sharedInstance.RBResizeImage(addImage.image!, targetSize: CGSize(width: 120, height: 120))
        SingletonC.sharedInstance.roomNewName = roomNametemp
        
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
            
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.createNewRoom(roomNametemp) {
                //if no feedback for 10 sec, close hud
                

            }else {
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        SingletonC.sharedInstance.checkSocketConnectionToOpen()
                        return
                    })
                    
                }
            return
                
        })
        
        
  
    }

    @IBAction func joinRoom(sender: UIButton) {
        // Form violation reminder
        
        //check network
        if !SingletonC.sharedInstance.checkSocketConnectionToOpen() {
            return
        }
        if !SingletonC.sharedInstance.loadUserInfoWithAlert() {
            return
        }
        
        let roomID = editRoomName.text
        SingletonC.sharedInstance.roomPicture = SingletonC.sharedInstance.RBResizeImage(addImage.image!, targetSize: CGSize(width: 120, height: 120))
        
        
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.joinRoom(roomID) {
                //check feedback
                
                
            }else {
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    SingletonC.sharedInstance.checkSocketConnectionToOpen()
                    return
                })
                
            }
            
        })
        
        
    }
    
    @IBAction func createID(sender: AnyObject) {
        //check uid is already have
        
        if SingletonC.sharedInstance.loadUserInfo() {
            let userid = SingletonC.sharedInstance.user[0].account
            let alertController = UIAlertController(title: "已有帳號", message: "已經擁有帳號：" + userid!, preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        //no user, and create a new one
        //set user picture
        SingletonC.sharedInstance.userPicture = SingletonC.sharedInstance.RBResizeImage(addImage.image!, targetSize: CGSize(width: 240, height: 240))
        //check internet
        if !SingletonC.sharedInstance.checkSocketConnectionToOpen() {
            return
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.createID() {
                
                //check feedback
                while SingletonC.sharedInstance.getedUserID == false {
                    //hangs for 1 secs
                    
                    //after 10 secs -> return & please try again
                }
                //success and send UI
                if let userID = SingletonC.sharedInstance.user[0].account {
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        SingletonC.sharedInstance.getedUserID = false
                        let alertController = UIAlertController(title: "註冊成功", message: "你的帳號名稱：" + userID, preferredStyle: .Alert)
                        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(doneAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        return
                    })
                }
                
                
            }else {
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    SingletonC.sharedInstance.checkSocketConnectionToOpen()
                    return
                })
            }

        })
    }

    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func PUSH(sender: AnyObject) {
        var notification = UILocalNotification() // create a new reminder notification
        notification.alertBody = "Reminder: Todo Item  Is Overdue" // text that will be displayed in the notification
        //notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate(timeIntervalSinceNow: 5) // 30 minutes from current time
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["roomid": "102", "roomname": "test1"] // assign a unique identifier to the notification that we can use to retrieve it later
        notification.category = "TEXT_CATEGORY"
        notification.alertTitle = "title"
        notification.applicationIconBadgeNumber = 1
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    @IBAction func ACCT(sender: AnyObject) {
        var notification = UILocalNotification() // create a new reminder notification
        notification.alertBody = "Reminder: some invite you to talk" // text that will be displayed in the notification
        //notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate(timeIntervalSinceNow: 5) // 30 minutes from current time
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["roomid": "102", "roomname": "test1"] // assign a unique identifier to the notification that we can use to retrieve it later
        notification.category = "ASK_CATEGORY"
        notification.applicationIconBadgeNumber = 5
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        self.addImage.image = nil
    }
    
    
        // If all fields are correctly filled in, extract the field value
        // Create Restaurant Object and save to data store
        
        
        
    func clearButton(notify: NSNotification) {
        //create room success and send UI
        //dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.editRoomName.text = ""
            self.buttonCreateRoom.enabled = false
            self.buttonJoinRoom.enabled = false
            self.addImage.image = nil
            SingletonC.sharedInstance.roomNewName = nil
        
            
            return
        //})
        
        
    }

    
    
    
    


}

