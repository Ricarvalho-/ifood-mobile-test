//
//  MockTimelineWorker.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 21/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

class MockTimelineWorker: TimelineWorker {
    func fetchTweets(after last: Tweet?, for user: User, completion: ([Tweet]?) -> Void) {
        var tweets = [Tweet]()
        for index in 1...50 {
            let shuffledScreenName = String((user.screenName?.shuffled() ?? [Character]()))
            let json = """
{
    "id_str": "\(String(index))",
    "full_text": "\(shuffledScreenName + String(index) + String(Array.init(repeating: "*", count: index)))",
    "retweet_count": \(index % 10 + index * 20),
    "favorite_count":  \(index % 5 + index * 35),
    "created_at": "Fri Dec 21 \(index % 12 * 2):\(index % 20 * 3):47 +0000 2018"        
}
"""
            guard let jsonData = json.data(using: .utf8) else {
                completion(nil)
                return
            }
            if let tweet = try? JSONDecoder().decode(Tweet.self, from: jsonData) {
                tweets.append(tweet)
            }
        }
        completion(tweets)
    }
    
    func cancelFetch() {
        
    }
}
