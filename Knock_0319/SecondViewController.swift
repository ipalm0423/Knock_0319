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


class SecondViewController: UIViewController, NSStreamDelegate {
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
        

        
    }
    
    override func viewDidAppear(animated: Bool) {
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
    
    @IBAction func createRoom(sender: UIButton) {
        // Form violation reminder
        
        //check network
        if SingletonC.sharedInstance.checkSocketConnection(self) == false {
            return
        }
        //check account
        if !SingletonC.sharedInstance.loadUserInfoWithAlert(self) {
            return
        }
        
        let roomNametemp = editRoomName.text
        // setup user picture
        SingletonC.sharedInstance.roomPicture = addImage.image
        SingletonC.sharedInstance.roomNewName = roomNametemp
        
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
            
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.createNewRoom(roomNametemp) {
                //check feedback
                while SingletonC.sharedInstance.getedRoomID == false {
                        //hangs for 1 secs
                        
                        //after 10 secs -> return & please try again
                }
                    //success and send UI
                if let roomID = SingletonC.sharedInstance.roomNewID {
                        dispatch_async(dispatch_get_main_queue(), {
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.editRoomName.text = ""
                            self.buttonCreateRoom.enabled = false
                            self.buttonJoinRoom.enabled = false
                            SingletonC.sharedInstance.roomNewID = nil
                            SingletonC.sharedInstance.roomNewName = nil
                            SingletonC.sharedInstance.getedRoomID = false
                            let alertController = UIAlertController(title: "成功建立房間", message: "新房間名稱：" + roomNametemp + ", id:" + roomID, preferredStyle: .Alert)
                            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertController.addAction(doneAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            return
                        })
                    }
                    

            }else {
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        SingletonC.sharedInstance.checkSocketConnection(self)
                        return
                    })
                    
                }
                
        })
        
        
  
    }

    @IBAction func joinRoom(sender: UIButton) {
        // Form violation reminder
        
        //check network
        if SingletonC.sharedInstance.checkSocketConnection(self) == false {
            return
        }
        if !SingletonC.sharedInstance.loadUserInfoWithAlert(self) {
            return
        }
        
        let roomID = editRoomName.text
        SingletonC.sharedInstance.roomPicture = addImage.image
        
        
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.joinRoom(roomID) {
                //check feedback
                while SingletonC.sharedInstance.getedRoomID == false {
                    //hangs for 1 secs
                    
                    //after 10 secs -> return & please try again
                }
                //success and send UI
                if let roomName = SingletonC.sharedInstance.roomNewName {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        self.editRoomName.text = ""
                        self.buttonCreateRoom.enabled = false
                        self.buttonJoinRoom.enabled = false
                        SingletonC.sharedInstance.roomNewID = nil
                        SingletonC.sharedInstance.roomNewName = nil
                        SingletonC.sharedInstance.getedRoomID = false
                        let alertController = UIAlertController(title: "成功建立房間", message: "新房間名稱：" + roomName + ", ID:" + roomID, preferredStyle: .Alert)
                        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(doneAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        return
                    })
                }
                
                
                
            }else {
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    SingletonC.sharedInstance.checkSocketConnection(self)
                    return
                })
                
            }
            
        })
        
        
    }
    
    @IBAction func createID(sender: AnyObject) {
        //check uid is already have
        
        if SingletonC.sharedInstance.loadUserInfo() {
            let userid = SingletonC.sharedInstance.user[0].uid
            let alertController = UIAlertController(title: "已有帳號", message: "已經擁有帳號：" + userid, preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        //no user, and create a new one
        //set user picture
        SingletonC.sharedInstance.userPicture = addImage.image
        //check internet
        if SingletonC.sharedInstance.checkSocketConnection(self) == false {
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
                if let userID = SingletonC.sharedInstance.user[0].uid {
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
                    SingletonC.sharedInstance.checkSocketConnection(self)
                    return
                })
            }

        })
    }

    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

        
    
    
    
        // If all fields are correctly filled in, extract the field value
        // Create Restaurant Object and save to data store
        
        
        
    

    
    
    
    


}

