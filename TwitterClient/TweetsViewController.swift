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
        Tweet.homeTimeline({ (tweets: [Tweet]) in
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
        return cell
    }

    func composeViewController(composeViewController: ComposeViewController, didSubmitText text: String) {
        print(text)
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
        if segue.identifier == "ComposeSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
            composeViewController.delegate = self
        }

        if segue.identifier == "TweetDetailsSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let tweetDetailsViewController = navigationController.topViewController as! TweetDetailsViewController

            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            tweetDetailsViewController.tweet = tweets[indexPath.row]
        }
    }

}
