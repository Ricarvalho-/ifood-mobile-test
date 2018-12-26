//
//  TwitterAPIUserSearchWorker.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 25/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation
import Alamofire

class TwitterAPIUserSearchWorker: UserSearchWorker {
    private var request: Request?
    private var canceled: Bool = false
    
    func fetchUser(with screenName: String, completion: @escaping (User?) -> Void) {
        canceled = false
        let baseURL = "https://api.twitter.com"
        let api = "/1.1/users/show.json"
        let url = baseURL + api
        let headers = ["Authorization": "Bearer \(TwitterAccessTokenManager.accessToken)"]
        let params: Parameters = [
            "include_entities": false,
            "screen_name": screenName
        ]
        
        request = Alamofire.request(url, parameters: params, headers: headers)
            .validate().responseData { [weak self] response in
                guard !(self?.canceled ?? true) else { return }
                switch response.result {
                case .success(let value):
                    completion(try? JSONDecoder().decode(User.self, from: value))
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
