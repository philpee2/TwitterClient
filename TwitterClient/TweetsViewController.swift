//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/16/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    var endpoint: TwitterStatusEndpoint!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        fetchData(refreshControl)
        // Do any additional setup after loading the view.

    }

    @objc private func fetchData(refreshControl: UIRefreshControl) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Tweet.getTimeline(endpoint, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }

    // MARK: - Table view

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.accessoryType = .None
        cell.onReply = {(tweet: Tweet) -> Void in
            self.performSegueWithIdentifier("ReplySegue", sender: tweet)

        }
        cell.onProfile = {(user: User) -> Void in
            self.performSegueWithIdentifier("UserProfileSegue", sender: user)
        }
        return cell
    }

    func composeViewController(composeViewController: ComposeViewController, didSubmitText text: String) {
        let tweet = Tweet(text: text)
        tweet.save()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        switch segue.identifier! {
        case "ComposeSegue":
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
            composeViewController.delegate = self
        case "TweetDetailsSegue":
            let tweetDetailsViewController = segue.destinationViewController as! TweetDetailsViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            tweetDetailsViewController.tweet = tweets[indexPath.row]
        case "UserProfileSegue":
            let userProfileViewController = segue.destinationViewController as! UserProfileViewController
            let user = sender as! User
            userProfileViewController.user = user
        case "ReplySegue":
            let tweet = sender as! Tweet
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
            composeViewController.starterText = "@\(tweet.author.screenName) "
            composeViewController.delegate = self
        default:
            return
        }
    }

}
