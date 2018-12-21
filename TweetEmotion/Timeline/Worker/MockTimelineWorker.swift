//
//  MockTimelineWorker.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 21/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

class MockTimelineWorker: TimelineWorker {
    func fetchTweets(after last: Tweet?, for user: User, _ completion: ([Tweet]?) -> Void) {
        var tweets = [Tweet]()
        for index in 1...20 {
            let json = """
{
    "created_at": "Fri Dec 21 13:28:47 +0000 2018",
    "id_str": "\(String(index))",
    "text": "\((user.screenName ?? "") + String(index * 5))",
    "retweet_count": \(index % 5),
    "favorite_count":  \(index % 4),
    "truncated": false
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
