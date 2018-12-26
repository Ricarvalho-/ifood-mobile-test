//
//  TwitterAPITimelineWorker.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 25/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation
import Alamofire

class TwitterAPITimelineWorker: TimelineWorker {
    private var request: Request?
    private var canceled: Bool = false
    
    func fetchTweets(after last: Tweet?, for user: User, completion: @escaping ([Tweet]?) -> Void) {
        canceled = false
        let baseURL = "https://api.twitter.com"
        let api = "/1.1/statuses/user_timeline.json"
        let url = baseURL + api
        let headers = ["Authorization": "Bearer \(TwitterAccessTokenManager.accessToken)"]
        var params: Parameters = [
            "tweet_mode": "extended",
            "trim_user": true,
            "include_entities": false,
            "exclude_replies": true,
            "include_rts": false,
            "count": 150,
            "user_id": user.id ?? ""
        ]
        
        if let lastId = last?.id {
            params["max_id"] = lastId
        }
        
        request = Alamofire.request(url, parameters: params, headers: headers)
            .validate().responseData { [weak self] response in
                guard !(self?.canceled ?? true) else { return }
                switch response.result {
                case .success(let value):
                    let tweets = try? JSONDecoder().decode([Tweet].self, from: value)
                    if last != nil, let tweets = tweets {
                        completion(Array(tweets.dropFirst()))
                    } else {
                        completion(tweets)
                    }
                    break
                case .failure:
                    if response.response?.statusCode == 401 {
                        TwitterAccessTokenManager.invalidateToken()
                    }
                    completion(nil)
                    break
                }
        }
    }
    
    func cancelFetch() {
        canceled = true
        request?.cancel()
    }
}
