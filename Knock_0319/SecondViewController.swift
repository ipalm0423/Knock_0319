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

    @IBOutlet weak var buttonCreateRoom: UIButton!
    
    @IBOutlet weak var editRoomName: UITextField!
    
    @IBOutlet weak var addImage: UIImageView!

    
    var roominformation: Roominfo!
    var userInformation: Userinfo!
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var errorField = ""
    
    

    @IBAction func textFieldRetur(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func closeKeyboard(sender: AnyObject) {
        editRoomName.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        



        
    }
    
    
    @IBAction func createRoom(sender: UIButton) {
        // Form violation reminder
        
        let roomNametemp = editRoomName.text
        
        if editRoomName.text == "" {
            errorField = "name"
        }
        
        if errorField != "" {
            
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed as you forget to fill in the " + errorField + ". All fields are mandatory.", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            errorField = ""
            
            return
        }
        
        

        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.AnnularDeterminate
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.createNewRoom(roomNametemp) {
                //get input stream
                if let inputdata = SingletonC.sharedInstance.getServerData() {
                    
                    
                    
                    let json = JSON(data: inputdata)
                    let roomID = json["roomid"].stringValue
                    
                    //input coreData
                    if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                        
                        self.roominformation = NSEntityDescription.insertNewObjectForEntityForName("Roominfo",
                            inManagedObjectContext: managedObjectContext) as Roominfo
                        self.roominformation.roomName = roomNametemp + ", ID:" + roomID
                        self.roominformation.image = UIImagePNGRepresentation(self.addImage.image)
                        //roominformation.isTimeup = 0
                        //            restaurant.isVisited = NSNumber.convertFromBooleanLiteral(isVisited)
                        var e: NSError?
                        if managedObjectContext.save(&e) != true {
                            println("insert error: \(e!.localizedDescription)")
                            
                        }
                        
                        
                        
                        //end HUDProcess
                        dispatch_async(dispatch_get_main_queue(), {
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            //self.editRoomName.text = ""
                            let alertController = UIAlertController(title: "Success", message: "new room is " + roomNametemp + ", roomid:" + roomID , preferredStyle: .Alert)
                            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertController.addAction(doneAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            return
                        })
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        let alertController = UIAlertController(title: "Oops", message: "Can't get feedback server.", preferredStyle: .Alert)
                        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(doneAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    })
                    
                }
                
                
                
            }else {
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    let alertController = UIAlertController(title: "Oops", message: "Please check your connection and try again.", preferredStyle: .Alert)
                    let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(doneAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                })
                
            }
 
        })
 
        
    }

    @IBAction func joinRoom(sender: UIButton) {
        // Form violation reminder
        
        let roomNametemp = editRoomName.text
        
        if editRoomName.text == "" {
            errorField = "room"
        }
        
        if errorField != "" {
            
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed as you forget to fill in the " + errorField + ". All fields are mandatory.", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            errorField = ""
            
            return
        }
        
        
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.AnnularDeterminate
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.joinRoom(roomNametemp) {
                //get input stream
                if let inputdata = SingletonC.sharedInstance.getServerData() {
                    
                    
                    
                    let json = JSON(data: inputdata)
                    let roomID = json["roomid"].stringValue
                    
                    //input coreData
                    if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                        
                        self.roominformation = NSEntityDescription.insertNewObjectForEntityForName("Roominfo",
                            inManagedObjectContext: managedObjectContext) as Roominfo
                        self.roominformation.roomName = "join room, ID:" + roomID
                        self.roominformation.image = UIImagePNGRepresentation(self.addImage.image)
                        //roominformation.isTimeup = 0
                        //            restaurant.isVisited = NSNumber.convertFromBooleanLiteral(isVisited)
                        var e: NSError?
                        if managedObjectContext.save(&e) != true {
                            println("insert error: \(e!.localizedDescription)")
                            
                        }
                        
                        
                        
                        //end HUDProcess
                        dispatch_async(dispatch_get_main_queue(), {
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            //self.editRoomName.text = ""
                            let alertController = UIAlertController(title: "Success", message: "join to new room, roomid:" + roomID , preferredStyle: .Alert)
                            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertController.addAction(doneAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            return
                        })
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        let alertController = UIAlertController(title: "Oops", message: "Can't get feedback server.", preferredStyle: .Alert)
                        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(doneAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    })
                    
                }
                
                
                
            }else {
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    let alertController = UIAlertController(title: "Oops", message: "Please check your connection and try again.", preferredStyle: .Alert)
                    let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(doneAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                })
                
            }
            
        })
        
        
    }
    
    @IBAction func createID(sender: AnyObject) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.AnnularDeterminate
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.createID() {
                //get input stream
                if let inputData = SingletonC.sharedInstance.getServerData() {
                    
                    let json = JSON(data: inputData)
                    let userid = json["id"].stringValue
                    
                    //input coreData
                    if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                        
                        self.userInformation = NSEntityDescription.insertNewObjectForEntityForName("Userinformation",
                            inManagedObjectContext: managedObjectContext) as Userinfo
                        self.userInformation.uid = userid
                        self.userInformation.picture = UIImagePNGRepresentation(self.addImage.image)
                        //roominformation.isTimeup = 0
                        //            restaurant.isVisited = NSNumber.convertFromBooleanLiteral(isVisited)
                        var e: NSError?
                        if managedObjectContext.save(&e) != true {
                            println("insert error: \(e!.localizedDescription)")
                            
                        }
                        
                        SingletonC.sharedInstance.loadUserInfo()
                        
                        //end HUDProcess
                        dispatch_async(dispatch_get_main_queue(), {
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            let alertController = UIAlertController(title: "Success", message: "Create New ID: " + userid, preferredStyle: .Alert)
                            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertController.addAction(doneAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            return
                        })
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        let alertController = UIAlertController(title: "Oops", message: "Can't get feedback server.", preferredStyle: .Alert)
                        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(doneAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    })
                    
                }
                
                
                
            }else {
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    let alertController = UIAlertController(title: "Oops", message: "Please check your connection and try again.", preferredStyle: .Alert)
                    let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(doneAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
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

