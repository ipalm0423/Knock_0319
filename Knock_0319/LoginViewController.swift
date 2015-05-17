//
//  LoginViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/14.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var accountField: UITextField!
    
    @IBOutlet weak var passwdField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var accountIcon: UIImageView!
    
    @IBOutlet weak var passwdIcon: UIImageView!
    
    @IBOutlet weak var nameIcon: UIImageView!
    
    
    @IBOutlet weak var passwdCont: NSLayoutConstraint!
    
    @IBOutlet weak var accountCont: NSLayoutConstraint!
    
    @IBOutlet weak var accountFieldConst: NSLayoutConstraint!
    
    @IBOutlet weak var passwdFieldConst: NSLayoutConstraint!
    
    @IBOutlet weak var pttButtonConst: NSLayoutConstraint!
    
    @IBOutlet weak var pttLabelConst: NSLayoutConstraint!
    
    @IBOutlet weak var pttLabel: UILabel!
    
    @IBOutlet weak var pttButton: UIButton!
    
    @IBOutlet weak var pictureViewImage: UIImageView!
    
    
    
    
    var imagePicker = UIImagePickerController()
    var isPTT = false
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
    
    @IBAction func pttButtonTouch(sender: AnyObject) {
        if isPTT {
            //返回沒有ptt
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, options: nil, animations: { () -> Void in
                
                self.accountCont.constant += 10
                self.passwdCont.constant += 10
                self.pttButtonConst.constant += 10
                
                self.view.layoutIfNeeded()
                }) { (Bool) -> Void in
                    self.pttLabel.text = "你可以直接登入PTT帳號，享受所有的服務"
                    self.pttButton.setTitle("你有PTT帳號嗎？", forState: UIControlState.Normal)
                    self.pttButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                    self.accountField.placeholder = "輸入你的帳號"
                    self.passwdField.placeholder = "輸入你的密碼"
                    self.isPTT = false
                    self.accountCont.constant = 20
                    self.passwdCont.constant = 20
                    self.pttButtonConst.constant -= 10
                    
            }
            
        }else {
            //進入有ptt
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, options: nil, animations: { () -> Void in
                self.accountCont.constant += 10
                self.passwdCont.constant += 10
                self.pttButtonConst.constant += 10
                
                self.view.layoutIfNeeded()
                }) {(Bool) -> Void in
                    self.pttLabel.text = "你可以建立新的Bomb的帳號，享受所有的服務"
                    self.pttButton.setTitle("沒有PTT帳號嗎?", forState: UIControlState.Normal)
                    self.pttButton.setTitleColor(UIColor.brownColor(), forState: UIControlState.Normal)
                    self.accountField.placeholder = "輸入你的PTT帳號"
                    self.passwdField.placeholder = "輸入你的PTT密碼"
                    self.isPTT = true
                    self.accountCont.constant = 20
                    self.passwdCont.constant = 20
                    self.pttButtonConst.constant -= 10
                    
            }
        }
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup camera
        imagePicker.delegate = self
        //setup picture gesture
        let tapPicture = UITapGestureRecognizer(target: self, action: "imageViewTouch:")
        self.pictureViewImage.addGestureRecognizer(tapPicture)
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
