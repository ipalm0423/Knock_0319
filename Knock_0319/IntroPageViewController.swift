//
//  IntroPageViewController.swift
//  Knock_0319
//
//  Created by 陳冠宇 on 2015/5/13.
//  Copyright (c) 2015年 Morpheus. All rights reserved.
//

import UIKit

class IntroPageViewController: UIViewController {
    
    var pageIndex: Int?
    var titleText : String!
    var subTitleText: String!
    var imageName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.introLabel.text = self.titleText
        self.subLabel.text = self.subTitleText
        self.introLabel.alpha = 0.1
        self.introImage.image = UIImage(named: self.imageName)
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.introLabel.alpha = 1.0
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var introLabel: UILabel!

    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var introImage: UIImageView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
