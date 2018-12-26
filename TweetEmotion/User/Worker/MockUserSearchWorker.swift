//
//  MockUserSearchWorker.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 21/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

class MockUserSearchWorker: UserSearchWorker {
    func fetchUser(with screenName: String, completion: @escaping (User?) -> Void) {
        guard !(screenName.contains("inexistent")) else {
            completion(nil)
            return
        }
        
        let json = """
{
    "id_str": "\(String(screenName.shuffled()))",
    "name": "\(String(screenName.shuffled()).localizedCapitalized)",
    "screen_name": "\(screenName)",
    "protected": \(screenName.contains("private")),
    "verified": \(screenName.contains("verified")),
    "profile_image_url_https": ""
}
"""
        guard let jsonData = json.data(using: .utf8) else {
            completion(nil)
            return
        }
        completion(try? JSONDecoder().decode(User.self, from: jsonData))
    }
    
    func cancelFetch() {
        
    }
}
