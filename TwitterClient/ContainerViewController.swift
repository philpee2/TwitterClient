//
//  ContainerViewController.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/18/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    var homeViewController: UINavigationController!
    var profileViewController: UserProfileViewController!
    var isOpen: Bool! {
        didSet {
            isOpen == false ? close() : open()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isOpen = false

        // Do any additional setup after loading the view.
        activeViewController = homeViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
            close()
        }
    }
    
    private func close() {
        UIView.animateWithDuration(0.2) {
            self.contentView.frame.origin.x = 0
        }
    }
    
    private func open() {
        UIView.animateWithDuration(0.2) {
            self.contentView.frame.origin.x = 200
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = contentView.bounds
            contentView.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
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
    @IBAction func onHome(sender: AnyObject) {
        activeViewController = homeViewController
    }

    @IBAction func onProfile(sender: AnyObject) {
        profileViewController.user = User.currentUser
        activeViewController = profileViewController
    }
    
    @IBAction func onScreenEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        print("panning")
    }
}
