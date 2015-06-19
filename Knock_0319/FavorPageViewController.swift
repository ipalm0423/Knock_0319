//
//  FavorPageViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class FavorPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //scroll parameter
    var startPoint = CGFloat(0)
    var profileBackgroundIsOpen = true
    
    var pageControl = 0
    var boards = [String]()
    var boardsIsShow = [Bool]()
    var titlesOfBoards = [String: Array<titletest>]() {
        didSet {
            boards = [String](titlesOfBoards.keys)
            boardsIsShow = [Bool](count: self.boards.count, repeatedValue: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        // Do any additional setup after loading the view.
        //test
        var test1 = titletest()
        var test2 = titletest()
        test2.picture = nil
        test2.title = "test2"
        test2.pushNumber = "100"
        self.titlesOfBoards["八卦版"] = [test1, test2, test1, test2]
        self.titlesOfBoards["西施版"] = [test1, test2]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //table view delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return boards.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.boardsIsShow[section] == true {
            if let titles = self.titlesOfBoards[boards[section]]{
                return titles.count
            }
        }
        return 0
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileCollectionViewCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
        let title = self.titlesOfBoards[boards[indexPath.section]]![indexPath.row]
        cell.titleLabel.text = title.title
        cell.accountLabel.text = title.account
        cell.pushLabel.text = title.pushNumber
        if let data = title.picture {
            cell.imageView.image = UIImage(data: data)
        }else {
            let effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            cell.blurView = UIVisualEffectView(effect: effect)
            cell.blurView.frame = cell.bounds
            cell.imageView.addSubview(cell.blurView)
        }
        return cell
    }
    
    //section view
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "titleCollectionHeader", forIndexPath: indexPath) as! ProfileHeaderCollectionReusableView
        header.sectionLabel.text = self.boards[indexPath.section]
        let tapGesture = UITapGestureRecognizer(target: self, action: "sectionHeaderTouch:")
        header.addGestureRecognizer(tapGesture)
        header.tag = indexPath.section
        return header
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.view.frame.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
    
    
    
    
    
    //button setup
    func sectionHeaderTouch(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            if let section = sender.view?.tag {
                if self.boardsIsShow[section] == false {
                    self.boardsIsShow[section] = true
                }else {
                    self.boardsIsShow[section] = false
                }
                self.collectionView.reloadSections(NSIndexSet(index: section))
            }
        }
    }
    
    //scrolling setup
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.startPoint = scrollView.panGestureRecognizer.translationInView(scrollView).y
        
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let finalPoint = scrollView.panGestureRecognizer.translationInView(scrollView).y
        if finalPoint > self.startPoint + 120 {
            if self.profileBackgroundIsOpen == false {
                NSNotificationCenter.defaultCenter().postNotificationName("openProfilePicture", object: nil)
                self.profileBackgroundIsOpen = true
            }
        }
        if finalPoint + 100 < self.startPoint {
            if self.profileBackgroundIsOpen == true {
                NSNotificationCenter.defaultCenter().postNotificationName("closeProfilePicture", object: nil)
                self.profileBackgroundIsOpen = false
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //did scroll to top
        if scrollView.contentOffset.y == 0 {
            if self.profileBackgroundIsOpen == false {
                NSNotificationCenter.defaultCenter().postNotificationName("openProfilePicture", object: nil)
                self.profileBackgroundIsOpen = true
            }
        }
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
