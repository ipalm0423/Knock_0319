//
//  DetailTitleViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/18.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class DetailTitleViewController: UIViewController, UIPageViewControllerDataSource{
    
    @IBOutlet weak var downButtonConst: NSLayoutConstraint!
    
    @IBOutlet weak var upButtonConst: NSLayoutConstraint!
    
    @IBOutlet weak var inputViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var segmentRightConst: NSLayoutConstraint!
    
    @IBOutlet weak var upButton: UIButton!
    
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var bombButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var pushTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var inputField: UITextField!
    
    
    
    //toggle
    var bombButtonShow = false
    var arrowButtonShow = false
    var inputFieldShow = false
    var hasKeyboardShow = false
    var inputBoxShow = false
    
    //page view controller
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var toolView: UIView!
    
    
    //article data
    var jsonRaw :JSON?
    var titleinfo: titletest!
    var articleID = [String]()
    
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
        var tapBackGroundGesture = UITapGestureRecognizer(target: self, action: "touchBackground:")
        self.view.addGestureRecognizer(tapBackGroundGesture)
        setupPageViewControl()
        
        //setup keyboard listner
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

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
        self.view.bringSubviewToFront(self.upButton)
        self.view.bringSubviewToFront(self.downButton)
        self.view.bringSubviewToFront(self.idLabel)
        self.view.bringSubviewToFront(self.inputField)
        self.view.bringSubviewToFront(self.toolView)
        self.view.bringSubviewToFront(self.pushTypeSegment)
        
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
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.inputViewBottomConst.constant = keyboardFrame.size.height
            self.bombAppearAnimate()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.inputViewBottomConst.constant = 0
            self.bombAppearAnimate()
        })
        
    }
    
    
    //button action
    
    func touchBackground(sender: UITapGestureRecognizer) {
        println("touch back")
        //return keyboard
        self.inputField.resignFirstResponder()
        
        //get back to all bomb button
        if self.bombButtonShow == true {
            self.bombAppearAnimate()
        }
        
    }
    
    
    @IBAction func bombButtonTouch(sender: AnyObject) {
        //send message
        
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
            self.toolView.backgroundColor = UIColor.greenColor()
        case 1 :
            self.toolView.backgroundColor = UIColor.redColor()
        default :
            self.toolView.backgroundColor = UIColor.grayColor()
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
                }, completion: nil)
        }else {
            //open button
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.segmentRightConst.constant += 170
                self.view.layoutIfNeeded()
                self.bombButtonShow = true
                }, completion: nil)
        }
    }
    
    
    
    
    
    
    
}
