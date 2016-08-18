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
    var author: User!
    
    var formattedTimestamp: String {
        return timestamp.asFormat()
    }

    var age: String {
        return NSDate().offsetFrom(timestamp)
    }

    init(dictionary: NSDictionary) {
        text = dictionary["text"] as! String
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        let authorDictionary = dictionary["user"] as! NSDictionary
        author = User(dictionary: authorDictionary)

        let timestampString = dictionary["created_at"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timestamp = formatter.dateFromString(timestampString)
    }
    
    // Convenience constructor for when a tweet is composed by the current user
    init(text: String) {
        self.text = text
        retweetCount = 0
        favoritesCount = 0
        author = User.currentUser
        timestamp = NSDate()
    }
    
    func save() {
        TwitterClient.sharedInstance.postTweet(self)
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        return dictionaries.map { Tweet(dictionary: $0) }
    }

    class func homeTimeline(success: ([Tweet]) -> Void, failure: ((NSError) -> Void)? = nil) {
        TwitterClient.sharedInstance.homeTimeline(success, failure: failure)
    }
}

func formatDate(dateString: String, inputFormat: String, outputFormat: String) -> String {
    // Copied from http://stackoverflow.com/a/32104865/4318086
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = inputFormat
    let date = dateFormatter.dateFromString(dateString)
    
    dateFormatter.dateFormat = outputFormat
    dateFormatter.timeZone = NSTimeZone(name: "UTC")
    return dateFormatter.stringFromDate(date!)
}


// Copied from 
// http://stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
extension NSDate {
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date: NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    func asFormat(outputFormat: String = "MM/DD/YY, H:mm a") -> String {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = outputFormat
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        return dateFormatter.stringFromDate(self)
    }
}