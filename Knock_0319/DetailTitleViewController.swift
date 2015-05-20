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
    
    @IBOutlet weak var replyRightConst: NSLayoutConstraint!
    
    
    
    
    
    
    var bombButtonshow = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
        
        let viewWidth = self.view.bounds.width
        self.pushRightConst.constant -= viewWidth
        self.replyRightConst.constant -= viewWidth
        
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
    
    @IBAction func backButtonTouch(sender: AnyObject) {
    }
    
    @IBAction func bombButtonTouch(sender: AnyObject) {
        let width = self.view.bounds.width
        if self.bombButtonshow {
            //close button
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.pushRightConst.constant -= width
                self.replyRightConst.constant -= width
                self.view.layoutIfNeeded()
                self.bombButtonshow = false
            }, completion: nil)
        }else {
            //open button
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.pushRightConst.constant += width
                self.replyRightConst.constant += width
                self.view.layoutIfNeeded()
                self.bombButtonshow = true
                }, completion: nil)
        }
    }
    
    @IBAction func pushButtonTouch(sender: AnyObject) {
    }
    
    @IBAction func badButtonTouch(sender: AnyObject) {
    }
   
    @IBAction func replyButtonTouch(sender: AnyObject) {
    }
    
    
    
    
    
}
