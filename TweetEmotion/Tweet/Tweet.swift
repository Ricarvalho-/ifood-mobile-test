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
    let retweets: Int?
    let favorites: Int?
    
    private let creationTimeUTC: String?
    private let limitedText: String?
    private let truncated: Bool?
    private let fullVersion: TweetExtension?
    
    var creationDate: Date? {
        guard let creationTimeUTC = creationTimeUTC else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZZZ yyyy"
        return dateFormatter.date(from: creationTimeUTC)
    }
    
    var text: String? {
        return truncated ?? false ? fullVersion?.text : limitedText
    }
    
    private enum CodingKeys: String, CodingKey {
        case creationTimeUTC = "created_at"
        case id = "id_str"
        case limitedText = "text"
        case retweets = "retweet_count"
        case favorites = "favorite_count"
        case truncated
        case fullVersion = "extended_tweet"
    }
    
    private struct TweetExtension: Codable {
        let text: String
        
        private enum CodingKeys: String, CodingKey {
            case text = "full_text"
        }
    }
}
