//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/16/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let baseUrl = "https://api.twitter.com"
let consumerKey = "FqGKgaQdhcqyNbhttPCGTWHUY"
let consumerSecret = "qttHBR50J4GLVWwIGe0POrgw9pW9nenTTgEIkX1JAJc76ofXH6"

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(
        baseURL: NSURL(string: baseUrl)!,
        consumerKey: consumerKey,
        consumerSecret: consumerSecret
    )
    
    var loginSucces: (() -> Void)?
    var loginFailure: ((NSError) -> Void)?
    
    func homeTimeline(success: ([Tweet]) -> Void, failure: ((NSError) -> Void)? = nil) {
        GET(
            "1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                success(tweets)
                
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure?(error)
            }
        )
    }
    
    func currentAccount(success: User -> Void, failure: ((NSError) -> Void)? = nil) {
        GET(
            "1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                success(user)
            },
            failure: { (task:NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure?(error)
            }
        )
    }
    
    func login(success: () -> Void, failure: ((NSError) -> Void)? = nil) {
        loginSucces = success
        loginFailure = failure
        deauthorize()
        fetchRequestTokenWithPath(
            "/oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "twitterclient://oauth"),
            scope: nil,
            success: { (token: BDBOAuth1Credential!) -> Void in
                let url = NSURL(string: "\(baseUrl)/oauth/authorize?oauth_token=\(token.token)")!
                UIApplication.sharedApplication().openURL(url)
                
            },
            failure: { (error: NSError!) -> Void in
                print(error.localizedDescription)
                failure?(error)
            }
        )
    }
    
    func logout() {
        deauthorize()
        User.currentUser = nil
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath(
            "/oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                self.currentAccount(
                    { (user: User) -> Void in
                        User.currentUser = user
                        self.loginSucces?()
                    },
                    failure: { (error: NSError) -> Void in
                        self.loginFailure?(error)
                    }
                )
                
            },
            failure: { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
            }
        )
    }
}
