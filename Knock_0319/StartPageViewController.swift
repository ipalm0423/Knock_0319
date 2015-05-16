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
    var identifiers = ["BoardPageViewController", "FavorPageViewController", "FollowingPageViewController", "FollowerPageViewController"]
    
    @IBOutlet weak var favorButton: UIBarButtonItem!
    
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    @IBOutlet weak var goodButton: UIBarButtonItem!
    
    @IBOutlet weak var penButton: UIBarButtonItem!
    
    
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
    @IBAction func boardButton(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        if let identifier = self.pageViewController.viewControllers[0].restorationIdentifier {
            if var index = find(self.identifiers, identifier!) {
                if (index == 0) {
                    //stay
                }else {
                    //backward
                    self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func favorButton(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(1)
        if let identifier = self.pageViewController.viewControllers[0].restorationIdentifier {
            if var index = find(self.identifiers, identifier!) {
                if (index == 1) {
                    //stay
                }else if index > 1{
                    //backward
                    self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
                }else {
                    //forward
                    self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func followingButton(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(2)
        if let identifier = self.pageViewController.viewControllers[0].restorationIdentifier {
            if var index = find(self.identifiers, identifier!) {
                if (index == 2) {
                    //stay
                }else if index > 2{
                    //backward
                    self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
                }else {
                    //forward
                    self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func follower(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(3)
        if let identifier = self.pageViewController.viewControllers[0].restorationIdentifier {
            if var index = find(self.identifiers, identifier!) {
                if (index == 3) {
                    //stay
                }else {
                    //backward
                    self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                }
            }
        }
    }
    

    //setup page view data source
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
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
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if var index = find(self.identifiers, identifier) {
                //if the index is the end of the array, return nil since we dont want a view controller after the last one
                if (index == 0) {
                    return nil
                }
                index = index - 1
                //increment the index to get the viewController after the current index
                return self.viewControllerAtIndex(index)
            }
        }
        return nil
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        //first
        if index == 0 {
            
            return self.storyboard?.instantiateViewControllerWithIdentifier("BoardPageViewController") as! BoardPageViewController
            
        }
        
        //second view controller
        if index == 1 {
            
            return self.storyboard?.instantiateViewControllerWithIdentifier("FavorPageViewController") as! FavorPageViewController
        }
        //third
        if index == 2 {
            
            return self.storyboard?.instantiateViewControllerWithIdentifier("FollowingPageViewController") as! FollowingPageViewController
        }
        
        //four
        if index == 3 {
            
            return self.storyboard?.instantiateViewControllerWithIdentifier("FollowerPageViewController") as! FollowerPageViewController
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
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.height - 30)
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
