//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/17/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

@objc protocol ComposeViewControllerDelegate {
    optional func composeViewController(composeViewController: ComposeViewController, didSubmitText text: String)
}

import UIKit

class ComposeViewController: UIViewController {
    
    var delegate: ComposeViewControllerDelegate?
    
    @IBOutlet weak var tweetField: UITextField!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    // TODO: Probably shouldn't be a UIBarButtonItem
    @IBOutlet weak var remainingCharacters: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tweetField.becomeFirstResponder()
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

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        let text = tweetField.text ?? ""
        if !text.isEmpty {
            delegate?.composeViewController?(self, didSubmitText: text)
        }
    }
    
    @IBAction func tweetFieldChanged(sender: AnyObject) {
        let characterCount = tweetField.text?.characters.count ?? 0
        remainingCharacters.title = "\(140 - characterCount)"
        
        if characterCount > 140 {
            submitButton.enabled = false
        } else {
            submitButton.enabled = true
        }
    }
}
