//
//  TimelinePresenter.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 19/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

protocol TimelineView: class {
    var timelineViewModel: TimelineViewModel { get set }
    func startTimelineLoading()
    func stopTimelineLoading()
    func addTweetViewModels(_: [TweetViewModel])
    func clearTweetViewModels()
}

protocol TimelinePresenter {
    func loadMoreTweets()
    init(with view: TimelineView)
}

class TimelinePresenterImpl: TimelinePresenter, TimelineInteractorDelegate {
    weak var view: TimelineView?
    private var interactor: TimelineInteractor? // impl
    
    required init(with view: TimelineView) {
        self.view = view
    }
    
    func loadMoreTweets() {
        interactor?.retrieveMoreTweets()
    }
    
    func didRetrieveTweets(_ tweets: [Tweet]) {
        view?.addTweetViewModels(tweets.map { ViewModel.init(from: $0) })
    }
    
    struct ViewModel: TweetViewModel {
        let date, text: String
        let favorites, retweets: Int
        let emotionalStatus: TweetEmotionalStatus
        
        init(from tweet: Tweet) {
            text = tweet.text ?? ""
            favorites = tweet.favorites ?? 0
            retweets = tweet.retweets ?? 0
            emotionalStatus = .none
            
            if let creationDate = tweet.creationDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                date = formatter.string(from: creationDate)
            } else {
                date = ""
            }
        }
    }
}
