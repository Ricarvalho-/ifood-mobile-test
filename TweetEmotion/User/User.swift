//
//  User.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 20/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String?
    let name: String?
    let screenName: String?
    let protected: Bool?
    let verified: Bool?
    let profileImageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id_str"
        case name
        case screenName = "screen_name"
        case protected
        case verified
        case profileImageURL = "profile_image_url_https"
    }
}
