//
//  IntroViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit
import TWMessageBarManager

class IntroViewController: UIViewController, UIPageViewControllerDataSource, UINavigationControllerDelegate {
    
    var introText = ["好無聊？", "想看的好多？", "默默無名？"]
    var subText = ["快來跟同好一起討論最愛的事情", "各種內容豐富的看板，找到你需要的資訊", "發表你的意見，找到你的小粉絲"]
    var introImageName = ["colortape1.jpg", "colortape2.jpg", "colortape3.jpg"]
    var pageViewController: UIPageViewController!
    var index = 0
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    
    @IBAction func createButtonTouch(sender: AnyObject) {
        Singleton.sharedInstance.ShowLoginView(true)
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        Singleton.sharedInstance.ShowLoginView(false)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load intro page view controller
        reset()
        //view setup
        self.skipButton.layer.cornerRadius = 5
        self.skipButton.clipsToBounds = true
        self.logInButton.layer.cornerRadius = 5
        self.logInButton.clipsToBounds = true
        self.createButton.layer.cornerRadius = 5
        self.createButton.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccess:", name: "LoginSegue", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "LoginSegue", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //set up page view controller's delegate
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as! IntroPageViewController).pageIndex {
            self.pageControl.currentPage = index
            if index == 2 {
                return nil
            }
            //increment the index to get the viewController after the current index
            
            index = index + 1
            
            return self.viewControllerAtIndex(index)
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as! IntroPageViewController).pageIndex {
            self.pageControl.currentPage = index
            //if the index is the end of the array, return nil since we dont want a view controller after the last one
            if index == 0 {
                return nil
            }
            //increment the index to get the viewController after the current index
            index = index - 1
            return self.viewControllerAtIndex(index)
        }
        return nil
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if index >= 3 {
            return nil
        }
        
        let contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("IntroPageViewController") as! IntroPageViewController
        contentViewController.titleText = self.introText[index]
        contentViewController.subTitleText = self.subText[index]
        contentViewController.imageName = self.introImageName[index]
        contentViewController.pageIndex = index
        return contentViewController
        
    }
    
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //set up page view controller
    func reset() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        /* We are substracting 20 because we have a start bar button whose height is 20*/
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.view.sendSubviewToBack(self.pageViewController.view)
        
        
        
    }
    
    //segue to main tab bar
    func loginSuccess(notify: NSNotification) {
        
        var tabBar = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
        self.presentViewController(tabBar, animated: true, completion: { () -> Void in
        tabBar.selectedIndex = 2
        })

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "skipLoginSegue" {
            
            if let VC = segue.destinationViewController as? MainTabBarViewController {
                println("skip regist/ login segue, send for mobile")
                VC.selectedIndex = 2
                
                
            }
        }
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        //close intro view
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
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
