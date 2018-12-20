//
//  TimelineInteractor.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 19/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

protocol TimelineInteractorDelegate: class {
    func didRetrieveTweets(_ tweets: [Tweet])
}

protocol TimelineInteractor {
    func retrieveMoreTweets()
    func cancelPendingTasks()
    init(with delegate: TimelineInteractorDelegate) // weak
}
