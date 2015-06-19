//
//  LoginViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/14.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import TWMessageBarManager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accountField: UITextField!
    
    @IBOutlet weak var passwdField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var nameFieldConst: NSLayoutConstraint!
    
    @IBOutlet weak var accountFieldConst: NSLayoutConstraint!
    
    @IBOutlet weak var passFieldConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var registButton: UIButton!
    
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var pttButtonConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var pttLabel: UILabel!
    
    @IBOutlet weak var pttButton: UIButton!
    
    //switch parameter
    var isRegist = false
    var isPtt = false
    
    
    
    /*
    var imagePicker = UIImagePickerController()
    func imageViewTouch(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            
            //tap on image
            let takePicture = UIAlertController(title: nil, message: "新增照片", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let usePhoto = UIAlertAction(title: "相片", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                    //self.imagePicker = UIImagePickerController()
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .PhotoLibrary
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                    
                }
            }
            let useCamera = UIAlertAction(title: "照相", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .Camera
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                }
            }
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            
            takePicture.addAction(usePhoto)
            takePicture.addAction(useCamera)
            takePicture.addAction(cancel)
            self.presentViewController(takePicture, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        self.pictureViewImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.pictureViewImage.image?.resizingMode
        self.pictureViewImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.pictureViewImage.layer.cornerRadius = 30.0
        
        self.pictureViewImage.clipsToBounds = true
        dismissViewControllerAnimated(true, completion: { () -> Void in
            let bounds = self.pictureViewImage.bounds
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, options: nil, animations: { () -> Void in
                self.pictureViewImage.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: 70.0, height: 70.0)
                self.view.layoutIfNeeded()
                
            }) { (Bool) -> Void in
                //self.pictureViewImage.bounds = bounds
            }
        })
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
    }
    
    */
    @IBAction func registedButtonTouch(sender: AnyObject) {
    }
    
    
    
    @IBAction func RegistButtonTouch(sender: AnyObject) {
        
        //check if empty
        var err = ""
        if self.accountField.text == "" {
            err += "帳號不能為空白"
        }else if self.passwdField.text == "" {
            err += "密碼不能為空白"
        }
        
        if self.isRegist == true {
            if self.nameField.text == "" {
                err += "暱稱不能為空白"
            }
        }
        
        if err != "" {
            TWMessageBarManager.sharedInstance().showMessageWithTitle("無法建立帳號", description: err, type: TWMessageBarMessageType.Error)
            return
        }
        
        //待調整，account = name Field
        let account = self.nameField.text
        let passwd = self.passwdField.text
        let email = self.accountField.text
        Singleton.sharedInstance.userinfotemp.account = account
        Singleton.sharedInstance.userinfotemp.passwd = passwd
        //待調整，email = account field
        Singleton.sharedInstance.userinfotemp.email = email
        
        if self.isRegist == true {
            //create new account
            Singleton.sharedInstance.signUp(account, passwd: passwd, picture: nil, isPTT: false)
        }else {
            if self.isPtt == false {
                //login with ptt
                
            }else {
                //login with knock
                
            }
        }
    }
    
    @IBAction func switchButtonTouch(sender: AnyObject) {
        self.switchAnimate()
    }
    
    
    @IBAction func pttButtonTouch(sender: AnyObject) {
        self.pttAnimate()
    }
    
    //keyboard call back
    @IBAction func keyBoardReturn(sender: AnyObject) {
        self.accountField.resignFirstResponder()
        self.passwdField.resignFirstResponder()
        self.nameField.resignFirstResponder()
        
    }
    
    @IBAction func returnKey(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    
    //close
    @IBAction func closeButtonTouch(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.frame.offset(dx: 0, dy: 500)
            }) { (Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup view
        self.registButton.layer.cornerRadius = 5
        self.registButton.clipsToBounds = true
        self.pttButton.layer.cornerRadius = 5
        self.pttButton.clipsToBounds = true
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        //setup oringinal view
        if self.isRegist == true {
            self.changeButton.setTitle("登入現有帳號", forState: UIControlState.Normal)
            self.registButton.setTitle("註冊", forState: UIControlState.Normal)
            self.pttButtonConst.constant += self.view.frame.width
            self.pttLabel.hidden = true
        }else {
            self.changeButton.setTitle("註冊新帳號", forState: UIControlState.Normal)
            self.registButton.setTitle("登入", forState: UIControlState.Normal)
            self.nameFieldConst.constant += self.view.frame.width
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchAnimate() {
        let frame = self.view.frame
        if self.isRegist == true {
            //open to log in
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.nameFieldConst.constant += frame.width
                self.pttButtonConst.constant = 20
                self.pttLabel.hidden = false
                self.view.layoutIfNeeded()
                }, completion: { (Bool) -> Void in
                    self.registButton.setTitle("登入", forState: UIControlState.Normal)
                    self.changeButton.setTitle("註冊新帳號", forState: UIControlState.Normal)
            })
            self.isRegist = false
        }else {
            //open to regist
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.nameFieldConst.constant = 20
                self.pttButtonConst.constant += frame.width
                self.pttLabel.hidden = true
                self.view.layoutIfNeeded()
                }, completion: { (Bool) -> Void in
                    self.registButton.setTitle("註冊", forState: UIControlState.Normal)
                    self.changeButton.setTitle("登入現有帳號", forState: UIControlState.Normal)
            })
            self.isRegist = true
        }
    }
    
    
    
    
    func pttAnimate() {
        let frame = self.view.frame
        if self.isPtt == false {
            //open to ptt log in
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.accountFieldConst.constant += frame.width
                self.passFieldConst.constant += frame.width
                self.view.layoutIfNeeded()
                }, completion: { (Bool) -> Void in
                    self.registButton.setTitle("PTT登入", forState: UIControlState.Normal)
                    self.accountField.placeholder = "PTT帳號"
                    self.passwdField.placeholder = "PTT密碼"
                    self.pttLabel.text = "沒有PTT？ 那就註冊新帳號吧！"
                    self.pttButton.setTitle("我沒有PTT帳號", forState: UIControlState.Normal)
            })
            UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.accountFieldConst.constant = 20
                self.passFieldConst.constant = 20
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.isPtt = true
        }else {
            //open to normal log in
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                self.accountFieldConst.constant += frame.width
                self.passFieldConst.constant += frame.width
                self.view.layoutIfNeeded()
                }, completion: { (Bool) -> Void in
                    self.registButton.setTitle("登入", forState: UIControlState.Normal)
                    self.accountField.placeholder = "帳號"
                    self.passwdField.placeholder = "密碼"
                    self.pttLabel.text = "你可以使用PTT帳號直接登入！"
                    self.pttButton.setTitle("PTT帳號登入", forState: UIControlState.Normal)
            })
            UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.accountFieldConst.constant = 20
                self.passFieldConst.constant = 20
                self.view.layoutIfNeeded()
                }, completion: nil)
            self.isPtt = false
        }
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
