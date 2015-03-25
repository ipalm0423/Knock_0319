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
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    

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
    
    
    @IBAction func send2(sender: UIButton) {
        // Form violation reminder
        var errorField = ""
        var roomNametemp = editRoomName.text
        
        if editRoomName.text == "" {
            errorField = "name"
        }
        
        if errorField != "" {
            
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed as you forget to fill in the restaurant " + errorField + ". All fields are mandatory.", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        

        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.AnnularDeterminate
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if SingletonC.sharedInstance.sendNewRoom() {
                //get input stream
                if let inputString = SingletonC.sharedInstance.getServerData() {
                    
                    //input coreData
                    if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
                        
                        self.roominformation = NSEntityDescription.insertNewObjectForEntityForName("Roominfo",
                            inManagedObjectContext: managedObjectContext) as Roominfo
                        self.roominformation.roomName = roomNametemp
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
                            self.editRoomName.text = ""
                            
                            //
                            let alertController = UIAlertController(title: "Success", message: "Create a New Room: " + inputString, preferredStyle: .Alert)
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

