//
//  TweetDetailsViewController.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/17/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, ComposeViewControllerDelegate {

    var tweet: Tweet!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = tweet.author.name
        screenNameLabel.text = "@\(tweet.author.screenName)"
        dateLabel.text = tweet.formattedTimestamp
        tweetTextLabel.text = tweet.text
        profileImageView.setImageWithURL(tweet.author.profileImageUrl)
        retweetsLabel.text = "\(tweet.retweetCount) RETWEETS"
        favoritesLabel.text = "\(tweet.favoritesCount) FAVORITES"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func composeViewController(composeViewController: ComposeViewController, didSubmitText text: String) {
        let tweet = Tweet(text: text)
        tweet.save()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        switch segue.identifier! {
        case "ReplySegue":
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = navigationController.topViewController as! ComposeViewController
            composeViewController.starterText = "@\(tweet.author.screenName) "
            composeViewController.delegate = self
        case "UserProfileSegue":
            let userProfileViewController = segue.destinationViewController as! UserProfileViewController
            userProfileViewController.user = tweet.author
        default:
            return
        }
    }
    @IBAction func onRetweetPress(sender: AnyObject) {
        tweet.retweet()
    }
    @IBAction func onFavoritePress(sender: AnyObject) {
        tweet.favorite()
    }

}
