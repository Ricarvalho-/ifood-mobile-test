//
//  Tweet.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 20/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

struct Tweet: Codable {
    let id: String?
    let text: String?
    let retweets: Int?
    let favorites: Int?
    private let creationTimeUTC: String?
    
    var creationDate: Date? {
        guard let creationTimeUTC = creationTimeUTC else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZZZ yyyy"
        return formatter.date(from: creationTimeUTC)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id_str"
        case text = "full_text"
        case retweets = "retweet_count"
        case favorites = "favorite_count"
        case creationTimeUTC = "created_at"
    }
}
