//
//  StartPageViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var identifiers = ["FavorPageViewController", "MyTitlePageViewController", "FollowingPageViewController"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup page view controller
        reset()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //bar button setup
    @IBAction func favorButton(sender: AnyObject) {
        
        if let identifier = self.pageViewController.viewControllers[0].restorationIdentifier {
            if var index = find(self.identifiers, identifier!) {
                if (index == 0) {
                    //stay
                    return
                }else {
                    //backward
                    if let pageContentViewController = self.viewControllerAtIndex(0) {
                        self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
        
    }
    
    @IBAction func chatButton(sender: AnyObject) {
        
        if let identifier = self.pageViewController.viewControllers[0].restorationIdentifier {
            if var index = find(self.identifiers, identifier!) {
                if (index == 1) {
                    //stay
                }else if index > 1{
                    let pageContentViewController = self.viewControllerAtIndex(1)
                    //backward
                    self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
                }else {
                    if let pageContentViewController = self.viewControllerAtIndex(1) {
                        //forward
                        self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func followingButtonTouch(sender: AnyObject) {
        if let identifier = self.pageViewController.viewControllers[0].restorationIdentifier {
            if let index = find(self.identifiers, identifier!) {
                if index == 2 {
                    return
                }else{
                    if let pageContentViewController = self.viewControllerAtIndex(2) {
                        self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    

    //setup page view data source
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let VC = viewController as? FollowingPageViewController {
            return nil
        }
        if let VC = viewController as? FavorPageViewController {
            var index = VC.pageControl
            index = index + 1
            //increment the index to get the viewController after the current index
            return self.viewControllerAtIndex(index)
        }
        /*
        if let identifier = viewController.restorationIdentifier {
            if var index = find(self.identifiers, identifier) {
                index = index + 1
                //if the index is the end of the array, return nil since we dont want a view controller after the last one
                if (index == self.identifiers.count) {
                    
                    return nil
                }
                //increment the index to get the viewController after the current index
                return self.viewControllerAtIndex(index)
            }
        }*/
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let VC = viewController as? FavorPageViewController {
            var index = VC.pageControl
            //if the index is the end of the array, return nil since we dont want a view controller after the last one
            if (index == 0) {
                return nil
            }
            index = index - 1
            //increment the index to get the viewController after the current index
            return self.viewControllerAtIndex(index)
            
        }
        if let VC = viewController as? FollowingPageViewController {
            return self.viewControllerAtIndex(2)
        }
        /*
        if let VC = viewController.restorationIdentifier {
            if var index = find(self.identifiers, identifier) {
                //if the index is the end of the array, return nil since we dont want a view controller after the last one
                if (index == 0) {
                    return nil
                }
                index = index - 1
                //increment the index to get the viewController after the current index
                return self.viewControllerAtIndex(index)
            }
        }*/
        return nil
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        //first
        if index == 0 {
            let VC = self.storyboard?.instantiateViewControllerWithIdentifier("FavorPageViewController") as! FavorPageViewController
            VC.pageControl = 0
            return VC
            
        }
        
        //second view controller
        if index == 1 {
            let VC = self.storyboard?.instantiateViewControllerWithIdentifier("FavorPageViewController") as! FavorPageViewController
            VC.pageControl = 1
            return VC
        }
        //third
        if index == 2 {
            let VC = self.storyboard?.instantiateViewControllerWithIdentifier("FollowingPageViewController") as! FollowingPageViewController
            
            return VC
        }
        
    //else
    return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func reset() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        /* We are substracting 20 because we have a start bar button whose height is 20*/
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height + 40)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
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
