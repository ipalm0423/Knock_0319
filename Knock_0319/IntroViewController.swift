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
    var introImageName = ["page1.jpg", "page2.jpg", "page3.jpg"]
    var pageViewController: UIPageViewController!
    var index = 0
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as! IntroPageViewController).pageIndex {
            //if the index is the end of the array, return nil since we dont want a view controller after the last one
            println(index)
            self.pageControl.currentPage = index
            if index == self.introText.count - 1 {
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
            println(index)
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
        if index >= self.introText.count {
            return nil
        }
        
        let contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("IntroPageViewController") as! IntroPageViewController
        contentViewController.titleText = self.introText[index]
        contentViewController.subTitleText = self.subText[index]
        contentViewController.imageName = self.introImageName[index]
        contentViewController.pageIndex = index
        return contentViewController
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return self.introText.count
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
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 70)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.view.bringSubviewToFront(self.pageControl)
        self.view.bringSubviewToFront(self.createButton)
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
