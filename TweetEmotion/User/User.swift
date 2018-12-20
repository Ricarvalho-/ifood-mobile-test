//
//  User.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 20/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

struct user: Codable {
    let name: String?
    let screenName: String?
    let protected: Bool?
    let verified: Bool?
    let profileImageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case screenName = "screen_name"
        case protected
        case verified
        case profileImageURL = "profile_image_url_https"
    }
}
