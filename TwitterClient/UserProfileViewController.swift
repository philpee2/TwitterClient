//
//  UserProfileViewController.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/17/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = user.name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
