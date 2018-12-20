//
//  TweetViewModel.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 19/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

protocol TweetViewModel {
    var date: String { get }
    var text: String { get }
    var favorites: Int { get }
    var retweets: Int { get }
    var emotionalState: TweetEmotionalStatus { get }
}

enum TweetEmotionalStatus {
    case loading
    case positive
    case neutral
    case negative
}
