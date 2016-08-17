//
//  Tweet.swift
//  TwitterClient
//
//  Created by phil_nachum on 8/16/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String!
    var timestamp: NSDate!
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as! String
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timestamp = formatter.dateFromString(timestampString)
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        return dictionaries.map { Tweet(dictionary: $0) }
    }
}
