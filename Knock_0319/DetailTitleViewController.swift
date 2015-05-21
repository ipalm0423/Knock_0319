//
//  DetailTitleViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/18.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class DetailTitleViewController: UIViewController {
    
    @IBOutlet weak var pushRightConst: NSLayoutConstraint!
    
    @IBOutlet weak var pushUpConst: NSLayoutConstraint!
   
    @IBOutlet weak var pushDownConst: NSLayoutConstraint!
    
    @IBOutlet weak var goUpConst: NSLayoutConstraint!
    
    @IBOutlet weak var goDownConst: NSLayoutConstraint!
    
    @IBOutlet weak var upButton: UIButton!
    
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var arrowButton: UIButton!
    
    @IBOutlet weak var pushDownButton: UIButton!
    
    @IBOutlet weak var pushUpButton: UIButton!
    
    @IBOutlet weak var bombButton: UIButton!
    
    
    var bombButtonShow = false
    var arrowButtonShow = false
    var inputFieldShow = false
    var hasKeyboardShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
        
        let viewWidth = self.view.bounds.width
        self.pushUpConst.constant -= 60
        self.pushDownConst.constant += 60
        self.goUpConst.constant -= 60
        self.goDownConst.constant += 60
        self.upButton.alpha = 0
        self.downButton.alpha = 0
        self.pushUpButton.alpha = 0
        self.pushDownButton.alpha = 0
        self.navigationController?.hidesBarsOnSwipe = true
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
    
    
    
    
    //button action
    
    @IBAction func touchBackground(sender: AnyObject) {
        println("touch back")
        self.arrowAppearAnimate()
        self.bombAppearAnimate()
    }
    
    
    @IBAction func bombButtonTouch(sender: AnyObject) {
        bombAppearAnimate()
        
    }
    
    @IBAction func pushButtonTouch(sender: AnyObject) {
        bombAppearAnimate()
    }
    
    @IBAction func badButtonTouch(sender: AnyObject) {
        bombAppearAnimate()
    }
   
    
    @IBAction func arrowButtonTouch(sender: AnyObject) {
        arrowAppearAnimate()
    }
    
    
    
    //animate func
    func bombAppearAnimate() {
        let width = self.view.bounds.width
        if self.bombButtonShow {
            //close button
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.pushUpButton.alpha = 0
                self.pushDownButton.alpha = 0
                self.pushUpConst.constant -= 60
                self.pushDownConst.constant += 60
                self.bombButton.setImage(UIImage(named: "bomb-fire-vec"), forState: UIControlState.Normal)
                self.view.layoutIfNeeded()
                self.bombButtonShow = false
                }, completion: nil)
        }else {
            //open button
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.pushUpButton.alpha = 1
                self.pushDownButton.alpha = 1
                self.pushUpConst.constant += 60
                self.pushDownConst.constant -= 60
                self.bombButton.setImage(UIImage(named: "pen-60-vec"), forState: UIControlState.Normal)
                self.view.layoutIfNeeded()
                self.bombButtonShow = true
                }, completion: nil)
        }
    }
    
    func arrowAppearAnimate() {
        let width = self.view.bounds.width
        if self.arrowButtonShow {
            //close button
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.upButton.alpha = 0
                self.downButton.alpha = 0
                self.goUpConst.constant -= 60
                self.goDownConst.constant += 60
                self.arrowButton.setImage(UIImage(named: "arrow-couple-vec"), forState: UIControlState.Normal)
                self.view.layoutIfNeeded()
                self.arrowButtonShow = false
                }, completion: nil)
        }else {
            //open button
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.upButton.alpha = 1
                self.downButton.alpha = 1
                self.goUpConst.constant += 60
                self.goDownConst.constant -= 60
                self.arrowButton.setImage(UIImage(named: "arrow-back-vec"), forState: UIControlState.Normal)
                self.view.layoutIfNeeded()
                self.arrowButtonShow = true
                }, completion: nil)
        }
    }
    
    
    
    func inputBoxAppearAnimate() {
        
    }
    
    
}
