//
//  TweetCell.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/17/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyIcon: UIImageView!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    
    var onReply: ((Tweet) -> Void)!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.author.name
            screenNameLabel.text = "@\(tweet.author.screenName)"
            ageLabel.text = tweet.age
            tweetTextLabel.text = tweet.text
            profileImageView.setImageWithURL(tweet.author.profileImageUrl)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let retweetTap = UITapGestureRecognizer(target: self, action: #selector(TweetCell.onRetweetTap))
        retweetTap.delegate = self
        retweetIcon.addGestureRecognizer(retweetTap)
        
        let favoriteTap = UITapGestureRecognizer(target: self, action: #selector(TweetCell.onFavoriteTap))
        favoriteTap.delegate = self
        favoriteIcon.addGestureRecognizer(favoriteTap)
        
        let replyTap = UITapGestureRecognizer(target: self, action: #selector(TweetCell.onReplyTap))
        replyTap.delegate = self
        replyIcon.addGestureRecognizer(replyTap)
    }
    
    @objc private func onRetweetTap() {
        tweet.retweet()
    }
    
    @objc private func onFavoriteTap() {
        tweet.favorite()
    }
    
    @objc private func onReplyTap() {
        onReply(tweet)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    @IBAction func onRetweetPress(sender: AnyObject) {
//        tweet.retweet()
//    }
//    @IBAction func onFavoritePress(sender: AnyObject) {
//        tweet.favorite()
//    }
}
