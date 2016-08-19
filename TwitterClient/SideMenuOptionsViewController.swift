//
//  SideMenuOptionsViewController.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/18/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class SideMenuOptionsViewController: UIViewController {
    
    var sideMenuViewController: SideMenuViewController!
    var profileViewController: UINavigationController!
    var homeViewController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("UserProfileNavigationController") as! UINavigationController
        (profileViewController.topViewController as! UserProfileViewController).user = User.currentUser
        homeViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        
        sideMenuViewController.contentViewController = homeViewController

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onProfile(sender: AnyObject) {
        sideMenuViewController.contentViewController = profileViewController
    }

    @IBAction func onHome(sender: AnyObject) {
        sideMenuViewController.contentViewController = homeViewController
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
