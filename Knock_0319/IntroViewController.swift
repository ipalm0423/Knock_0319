//
//  IntroViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIPageViewControllerDataSource {
    
    var introText = ["好無聊？", "想看的好多？", "默默無名？"]
    var subText = ["快來跟同好一起討論最愛的事情", "各種內容豐富的看板，找到你需要的資訊", "發表你的意見，找到你的小粉絲"]
    var introImageName = ["colortape1.jpg", "colortape2.jpg", "colortape3.jpg"]
    var pageViewController: UIPageViewController!
    var index = 0
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    @IBAction func createButtonTouch(sender: AnyObject) {
        if let currentVC = pageViewController.viewControllers[0] as? LoginViewController {
            let account = currentVC.accountField.text
            let passwd = currentVC.passwdField.text
            let name = currentVC.nameField.text
            //show name field
            if currentVC.nameField.alpha == 0 {
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    currentVC.nameField.alpha = 1
                    currentVC.nameIcon.alpha = 1
                    }, completion: nil)
                return
            }
            //check information erro
            var err = ""
            if account == "" {
                err += "帳號不能為空白"
            }else if passwd == "" {
                err += "密碼不能為空白"
            }else if name == "" {
                err += "匿名名稱不能為空白"
            }
            if err != "" {
                TWMessageBarManager.sharedInstance().showMessageWithTitle("無法登入", description: err, type: TWMessageBarMessageType.Error)
            }else {
                //create new account
                
                
                //wait set up ......
                /*
                NSNotificationCenter.defaultCenter().postNotificationName("LoginAccount", object: nil)
                */
            }
            
        }else {
            //jump into page 3
            let pageContentViewController = self.viewControllerAtIndex(3)
            self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            self.pageControl.currentPage = 3
        }
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        if let currentVC = pageViewController.viewControllers[0] as? LoginViewController {
            let account = currentVC.accountField.text
            let passwd = currentVC.passwdField.text
            if currentVC.nameField.alpha == 1 {
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    currentVC.nameField.alpha = 0
                    currentVC.nameIcon.alpha = 0
                    }, completion: nil)
                return
            }
            //check information erro
            var err = ""
            if account == "" {
                err += "帳號不能為空白"
            }else if passwd == "" {
                err += "密碼不能為空白"
            }
            if err != "" {
                TWMessageBarManager.sharedInstance().showMessageWithTitle("無法登入", description: err, type: TWMessageBarMessageType.Error)
            }else {
                //login old account
                
                
                //wait set up ......
                /*
                NSNotificationCenter.defaultCenter().postNotificationName("LoginAccount", object: nil)
                */
            }
        }else {
            //jump into page 3
            let pageContentViewController = self.viewControllerAtIndex(3)
            self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
            //hide name field & icon
            if let currentVC = self.pageViewController.viewControllers[0] as? LoginViewController {
                currentVC.nameField.alpha = 0
                currentVC.nameIcon.alpha = 0
                
            }
            //set up page number
            self.pageControl.currentPage = 3
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccess:", name: "LoginAccount", object: nil)
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //set up page view controller's delegate
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        //check last one
        if let identifier = viewController.restorationIdentifier {
            //if the index is the end, return nil since we dont want a view controller after the last one
            if identifier == "LoginViewController" {
                self.pageControl.currentPage = 3
                println("last")
                return nil
            }else {
                if var index = (viewController as! IntroPageViewController).pageIndex {
                    self.pageControl.currentPage = index
                    println(index)
                    //increment the index to get the viewController after the current index
                    
                    index = index + 1
                    
                    return self.viewControllerAtIndex(index)
                }
            }
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            //if the index is the end, return nil since we dont want a view controller after the last one
            if identifier == "LoginViewController" {
                println("last")
                self.pageControl.currentPage = 3
                return self.viewControllerAtIndex(2)
            }else {
                if var index = (viewController as! IntroPageViewController).pageIndex {
                    self.pageControl.currentPage = index
                    println(index)
                    //if the index is the end of the array, return nil since we dont want a view controller after the last one
                    if index == 0 {
                        return nil
                    }
                    //increment the index to get the viewController after the current index
                    index = index - 1
                    return self.viewControllerAtIndex(index)
                }
            }
        }
        return nil
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if index >= 4 {
            return nil
        }
        if index == 3 {
            let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            return loginViewController
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
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 105)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.view.bringSubviewToFront(self.pageControl)
        
    }
    
    //segue to main tab bar
    func loginSuccess(notify: NSNotification) {
        
        var tabBar = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
        self.presentViewController(tabBar, animated: true, completion: { () -> Void in
        tabBar.selectedIndex = 2
        })

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
