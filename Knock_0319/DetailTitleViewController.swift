//
//  DetailTitleViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/18.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class DetailTitleViewController: UIViewController, UIPageViewControllerDataSource{
    
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
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var idLabel: UILabel!
    
    
    
    
    //toggle
    var bombButtonShow = false
    var arrowButtonShow = false
    var inputFieldShow = false
    var hasKeyboardShow = false
    
    //page view controller
    var pageViewController: UIPageViewController!
    
    
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
        self.pushUpConst.constant -= 60
        self.pushDownConst.constant += 60
        self.goUpConst.constant -= 60
        self.goDownConst.constant += 60
        self.upButton.alpha = 0
        self.downButton.alpha = 0
        self.pushUpButton.alpha = 0
        self.pushDownButton.alpha = 0
        self.navigationController?.hidesBarsOnSwipe = true
        
        
        var tapBackGroundGesture = UITapGestureRecognizer(target: self, action: "touchBackground:")
        self.view.addGestureRecognizer(tapBackGroundGesture)
        setupPageViewControl()
        
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
        self.view.bringSubviewToFront(self.bombButton)
        self.view.bringSubviewToFront(self.arrowButton)
        self.view.bringSubviewToFront(self.upButton)
        self.view.bringSubviewToFront(self.downButton)
        self.view.bringSubviewToFront(self.pushUpButton)
        self.view.bringSubviewToFront(self.pushDownButton)
        self.view.bringSubviewToFront(self.idLabel)
        
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
    
    func touchBackground(sender: UITapGestureRecognizer) {
        println("touch back")
        //return keyboard
        if let VC = self.pageViewController.viewControllers[0] as? ArticlePageViewController {
            if let cell = VC.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 4)) as? LastTableViewCell {
                cell.pushField.resignFirstResponder()
            }
        }
        //get back to all bomb button
        if self.arrowButtonShow == false && self.bombButtonShow == false {
            self.arrowAppearAnimate()
            self.bombAppearAnimate()
            return
        }
        if self.arrowButtonShow == true {
            self.arrowAppearAnimate()
        }
        if self.bombButtonShow == true {
            self.bombAppearAnimate()
        }
        
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
        //unwind to main
        if self.arrowButtonShow == true {
            self.performSegueWithIdentifier("returnMainViewSegue", sender: self)
        }else{
            arrowAppearAnimate()
        }
        
        
    }
    
    @IBAction func arrowUpTouch(sender: AnyObject) {
        arrowAppearAnimate()
    }
    
    @IBAction func arrowDown(sender: AnyObject) {
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
