//
//  SideMenuViewController.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/18/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    var optionsViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(optionsViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            UIView.animateWithDuration(0.2, animations: {
                self.contentViewConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == .Began {
            originalLeftMargin = contentViewConstraint.constant
        } else if sender.state == .Changed {
            contentViewConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == .Ended {
            UIView.animateWithDuration(0.2, animations: {
                if velocity.x > 0 {
                    self.contentViewConstraint.constant = self.view.frame.width - 100
                } else if  velocity.x < 0 {
                    self.contentViewConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
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
