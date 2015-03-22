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
    @IBOutlet weak var buttonCreate: UIButton!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save() {
        
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
        
        self.sendNewRoom()
        
        editRoomName.text = ""
        
        //input coreData
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext {
            
            roominformation = NSEntityDescription.insertNewObjectForEntityForName("Roominfo",
                inManagedObjectContext: managedObjectContext) as Roominfo
            roominformation.roomName = roomNametemp
            roominformation.image = UIImagePNGRepresentation(addImage.image)
            //roominformation.isTimeup = 0
            //            restaurant.isVisited = NSNumber.convertFromBooleanLiteral(isVisited)
            
            
            
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
            
            
        }
    
    
    func send(message:JSON){
        
        
        if  appDelegate.writeStream!.hasSpaceAvailable { //stream ready for input
            //println("true hasSpaceAvailable")
            var data:NSData
            
            var thisMessage = message.stringValue

            data = thisMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
 
            
            let bytesWritten = appDelegate.writeStream!.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
            
        }
        
        
    }
        
    func sendNewRoom() {

        if  appDelegate.writeStream!.hasSpaceAvailable {

            let message = "{\"method\": \"new\"}"
            var data = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            
            let bytesWritten = appDelegate.writeStream!.write(UnsafePointer<UInt8>(data!.bytes), maxLength: data!.length)
            
        }

        
        }
        
    
        // If all fields are correctly filled in, extract the field value
        // Create Restaurant Object and save to data store
        
        
        
    
    
    
    
    


}

