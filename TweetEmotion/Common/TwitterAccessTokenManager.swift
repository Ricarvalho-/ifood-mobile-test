//
//  TwitterAccessTokenManager.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 25/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation
import KeychainAccess
import Alamofire

class TwitterAccessTokenManager {
    private static let keychain = Keychain(service: "ricarvalho.TweetEmotion")
    private static let twitterTokenKey = "twitterAccessToken"
    
    static var accessToken: String {
        if let token = keychain[twitterTokenKey] {
            return token
        }
        if let token = TwitterTokenRequester.requestTwitterAccessToken() {
            keychain[twitterTokenKey] = token
            return token
        }
        
        return ""
    }
    
    static func invalidateToken() {
        keychain[twitterTokenKey] = nil
    }
}

private class TwitterTokenRequester {
    private static let apiKey = "51eRmPMZnpNYJYLok1d2toxcy"
    private static let apiSecretKey = "B0H6zWjYUaN6rLHZSkpGI0mGrQkHrwz1F0ydQqhCG25mrTpHZM"
    
    static func requestTwitterAccessToken() -> String? {
        let baseURL = "https://api.twitter.com"
        let api = "/oauth2/token"
        let url = baseURL + api
        let base64Keys = (apiKey + ":" + apiSecretKey).data(using: .utf8)?.base64EncodedString() ?? ""
        let headers = [
            "Authorization": "Basic \(base64Keys)",
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
        ]
        let params = ["grant_type": "client_credentials"]
        
        let semaphore = DispatchSemaphore(value: 0)
        var accessToken: String?
        
        Alamofire.request(url,
                          method: .post,
                          parameters: params,
                          headers: headers)
            .validate().responseData { response in
                if response.result.isSuccess,
                    let value = response.result.value,
                    let oauth = try? JSONDecoder().decode(Oauth2Token.self, from: value),
                    oauth.type == "bearer" {
                    
                    accessToken = oauth.token
                }
                semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        return accessToken
    }
    
    private struct Oauth2Token: Codable {
        let type: String?
        let token: String?
        
        private enum CodingKeys: String, CodingKey {
            case type = "token_type"
            case token = "access_token"
        }
    }
}
