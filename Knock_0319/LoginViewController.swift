//
//  LoginViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/14.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accountField: UITextField!
    
    @IBOutlet weak var passwdField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var pttAccountField: UITextField!
    
    @IBOutlet weak var pttPasswdField: UITextField!
    
    @IBOutlet weak var pttImage: UIImageView!
    
    
    @IBOutlet weak var pttLabel: UILabel!
    
    @IBOutlet weak var pttButton: UIButton!
    
    //constraint
    @IBOutlet weak var pttLabelConst: NSLayoutConstraint!
    
    @IBOutlet weak var pttLabel2Const: NSLayoutConstraint!
    
    //keyboard feekback
    
    @IBAction func pttButtonTouch(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.pttLabelConst.constant += self.view.bounds.width
            self.pttLabel2Const.constant += self.view.bounds.width
        }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.pttAccountField.alpha = 1.0
            self.pttPasswdField.alpha = 1.0
            self.view.layoutIfNeeded()
        }) { (Bool) -> Void in
            
        }
    }
    
    //keyboard call back
    @IBAction func keyBoardReturn(sender: AnyObject) {
        self.accountField.resignFirstResponder()
        self.passwdField.resignFirstResponder()
        self.nameField.resignFirstResponder()
        self.pttAccountField.resignFirstResponder()
        self.pttPasswdField.resignFirstResponder()
        
    }
    
    @IBAction func returnKey(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pttAccountField.alpha = 0.0
        self.pttPasswdField.alpha = 0.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
