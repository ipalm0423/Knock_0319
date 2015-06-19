//
//  DetailTitleViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/18.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class DetailTitleViewController: UIViewController, UIPageViewControllerDataSource{
    
    
    @IBOutlet weak var inputViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var segmentRightConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var bombButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var pushTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var fingerButton: UIButton!
    
    @IBOutlet weak var fingerButtonYConst: NSLayoutConstraint!
    
    @IBOutlet weak var fingerButtonXConst: NSLayoutConstraint!
    
    
    //toggle
    var bombButtonShow = false
    var arrowButtonShow = false
    var inputFieldShow = false
    var inputBoxShow = false
    
    //page view controller
    var sourceViewController = ""
    var pageViewController: UIPageViewController!
    var parentViewName = ""
    @IBOutlet weak var toolView: UIView!
    
    
    //article data
    var jsonRaw :JSON?
    var titleinfo: titletest!
    var articleID = [String]()
    
    //finger button
    var firstFingerPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setup view controller data
        //test only
        self.articleID = ["page1ID", "page2ID"]
        
        
        //setup button, navigator
        let viewWidth = self.view.bounds.width
        self.segmentRightConst.constant -= 170
        self.pushTypeSegment.selectedSegmentIndex = 2
        self.navigationController?.hidesBarsOnSwipe = true
        //add gesture touch background for return KB
        var tapBackGroundGesture = UITapGestureRecognizer(target: self, action: "touchBackground:")
        self.view.addGestureRecognizer(tapBackGroundGesture)
        setupFingerButtonPosition()
        setupPageViewControl()
        
        //setup keyboard listner
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("hideKeyboardAction:"), name: "hideKeyBoard", object: nil)
        
    }

    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //setup next page view controller
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as! ArticlePageViewController).pageIndex {
            index = index + 1
            if index == self.articleID.count {
                //last page
                self.pageControl.currentPage = index - 1
                return nil
            }else {
                //go on next page
                self.pageControl.currentPage = index
                //increment the index to get the viewController after the current index
                
                return self.viewControllerAtIndex(index)
            }
        }
        return nil
    }
    
    //setup previous page
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as! ArticlePageViewController).pageIndex {
            if index == 0 {
                //first page
                self.pageControl.currentPage = 0
                return nil
            }else {
                //go on before page
                self.pageControl.currentPage = index
                //increment the index to get the viewController after the current index
                index = index - 1
                return self.viewControllerAtIndex(index)
            }
        }
        return nil
    }
    
    
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        let contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ArticlePageViewController") as! ArticlePageViewController
        //set up page content
        contentViewController.pageIndex = index
        //contentViewController.pagetitle.text = self.articles[index]
        contentViewController.titleinfo = self.titleinfo
        self.idLabel.text = self.titleinfo.account
        
        
        
        return contentViewController
        
    }
    
    func setupPageViewControl() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        //bring button to front
        self.view.bringSubviewToFront(self.pageControl)
        self.view.bringSubviewToFront(self.idLabel)
        self.view.bringSubviewToFront(self.inputField)
        self.view.bringSubviewToFront(self.toolView)
        self.view.bringSubviewToFront(self.pushTypeSegment)
        self.view.bringSubviewToFront(self.fingerButton)
        
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //keyboard return
    @IBAction func keyboardReturn(sender: AnyObject) {
        sender.resignFirstResponder()
        
    }
    
    
    //keyboard animation
    func hideKeyboardAction(notification: NSNotification) {
        self.inputField.resignFirstResponder()
    }
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight = keyboardFrame.size.height
        
        //animate keyboard
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.inputViewBottomConst.constant = keyboardFrame.size.height
            self.bombAppearAnimate()
        })
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - keyboardHeight)
            }) { (Bool) -> Void in
                //scroll to down
                self.scrollToDown(true)
        }
    }
    
    
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.inputViewBottomConst.constant = 0
            self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            self.bombAppearAnimate()
        })
    }
    
    
    //button action
    
    func touchBackground(sender: UITapGestureRecognizer) {
        println("touch back")
        //return keyboard
        self.inputField.resignFirstResponder()
    }
    
    
    @IBAction func bombButtonTouch(sender: AnyObject) {
        //send message
        
    }
    
    
    @IBAction func fingerButtonTouch(sender: AnyObject) {
        println(sender.description)
        if let button = sender as? UIButton {
            button
        }
    }
    
    @IBAction func arrowButtonTouch(sender: AnyObject) {
        //unwind to main
        if self.arrowButtonShow == true {
            self.performSegueWithIdentifier("returnMainViewSegue", sender: self)
        }else{
            
        }
        
        if self.bombButtonShow == true {
            self.bombAppearAnimate()
        }
        
    }
    
    @IBAction func arrowUpTouch(sender: AnyObject) {
        
        if let VC = self.pageViewController.viewControllers[0] as? ArticlePageViewController {
            VC.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        if self.bombButtonShow == true {
            self.bombAppearAnimate()
        }
    }
    
    @IBAction func arrowDown(sender: AnyObject) {
        
        if let VC = self.pageViewController.viewControllers[0] as? ArticlePageViewController {
            VC.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        if self.bombButtonShow == true {
            self.bombAppearAnimate()
        }
    }
    
    
    @IBAction func segmentTouch(sender: AnyObject) {
        println("touch")
        let selected = self.pushTypeSegment.selectedSegmentIndex
        println(selected)
        switch selected {
        case 0 :
            self.toolView.backgroundColor = UIColor.redColor()
        case 1 :
            self.toolView.backgroundColor = UIColor.greenColor()
        default :
            self.toolView.backgroundColor = UIColor.grayColor()
        }
    }
    
    @IBAction func panFingerButton(sender: AnyObject) {
        if let pan = sender as? UIPanGestureRecognizer {
            var translatePoint = pan.translationInView(self.view)
            if pan.state == UIGestureRecognizerState.Began {
                firstFingerPoint = sender.view!!.center
            }
            
            if let view = sender.view {
                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    view!.center = CGPoint(x:view!.center.x + translatePoint.x,
                        y:view!.center.y + translatePoint.y)
                }, completion: nil)
                
                if pan.state == UIGestureRecognizerState.Ended {
                    var velocity = pan.velocityInView(self.view)
                    if velocity.x < -500 {
                        //go back previous VC
                        self.backButtonTrigger()
                    }
                    //back to oringinal point
                    if abs(velocity.y) > 500 {
                        //rolling the table
                        self.rollingTable(velocity.y)
                        //back to oringinal point
                        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                            view!.center = self.firstFingerPoint
                            }, completion: nil)
                    }else if abs(velocity.x) < 500 && abs(velocity.y) < 500 {
                        Singleton.sharedInstance.fingerOffsetPoint.x += view!.center.x - firstFingerPoint.x
                        Singleton.sharedInstance.fingerOffsetPoint.y += view!.center.y - firstFingerPoint.y
                        
                    }
                }
            }
            
            sender.setTranslation(CGPointZero, inView: self.view)
            
            

            
        }
    }
    
    
    //animate func
    func bombAppearAnimate() {
        let width = self.view.bounds.width
        if self.bombButtonShow {
            //close button
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.segmentRightConst.constant -= 170
                self.view.layoutIfNeeded()
                self.bombButtonShow = false
                self.fingerButton.hidden = false
                self.toolView.alpha = 0.7
                }, completion: nil)
        }else {
            //open button
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.segmentRightConst.constant += 170
                self.view.layoutIfNeeded()
                self.bombButtonShow = true
                self.fingerButton.hidden = true
                self.toolView.alpha = 1
                }, completion: nil)
        }
    }
    
    
    //back to oringinal page
    func backButtonTrigger() {
        if self.sourceViewController == "SmallTableViewController" {
            self.performSegueWithIdentifier("returnToSmallViewController", sender: self)
        }else if self.sourceViewController == "MainViewController" {
            self.performSegueWithIdentifier("returnMainViewSegue", sender: self)
        }
    }
    
    //scroll to down
    func scrollToDown(bool: Bool) {
        if let VC = self.pageViewController.viewControllers[0] as? ArticlePageViewController {
            if bool == true {
                VC.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }else if bool == false {
                VC.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
    }
    //rolling table
    func rollingTable(velocity: CGFloat) {
        if velocity > 500 {
            self.scrollToDown(true)
        }else if velocity < -500 {
            self.scrollToDown(false)
        }
    }
    
    //setup finger button position
    func setupFingerButtonPosition() {
        let offset = Singleton.sharedInstance.fingerOffsetPoint
        if offset != CGPoint(x: 0, y: 0) {
            self.fingerButtonXConst.constant -= offset.x
            self.fingerButtonYConst.constant -= offset.y
            println(self.fingerButtonXConst)
            println(self.fingerButtonYConst)
        }
    }
}
