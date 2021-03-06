//
//  TimelinePresenter.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 19/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import UIKit

protocol TimelineView: class {
    var timelineViewModel: TimelineViewModel? { get set }
    func startTimelineLoading()
    func stopTimelineLoading()
    func addTweetViewModels(_ viewModels: [TweetViewModel])
    func clearTweetViewModels()
}

protocol TimelinePresenter {
    func loadMoreTweets()
    func cancelTweetsRetrieval()
    init(with view: TimelineView)
}

class TimelinePresenterImpl: TimelinePresenter, TimelineInteractorDelegate {
    weak var view: TimelineView?
    private lazy var interactor: TimelineInteractor = TimelineInteractorImpl(with: self)
    private var debounceTimer: Timer?
    
    required init(with view: TimelineView) {
        self.view = view
        view.timelineViewModel = TimelineStatus.empty.viewModel
    }
    
    func loadMoreTweets() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.view?.startTimelineLoading()
            self?.interactor.retrieveMoreTweets()
        })
    }
    
    func cancelTweetsRetrieval() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.view?.stopTimelineLoading()
            self?.interactor.cancelPendingTasks()
        })
    }
    
    func didRetrieveTweets(_ tweets: [Tweet]) {
        stopLoadingAndSetViewModel(for: .filled)
        view?.addTweetViewModels(tweets.map { ViewModel.init(from: $0) })
    }
    
    private func stopLoadingAndSetViewModel(for status: TimelineStatus) {
        view?.stopTimelineLoading()
        view?.timelineViewModel = status.viewModel
    }
    
    private struct ViewModel: TweetViewModel {
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

extension TimelinePresenterImpl: UserSearchDelegate {
    func didUpdateToValidUser(_ user: User) {
        view?.clearTweetViewModels()
        view?.startTimelineLoading()
        view?.timelineViewModel = TimelineStatus.empty.viewModel
        interactor.retrieveInitialTweets(for: user)
    }
    
    func didUpdateToPrivateUser() {
        clearTweetsStopLoadingAndSetViewModel(for: .privateUser)
    }
    
    func didUpdateToNotFoundUser() {
        clearTweetsStopLoadingAndSetViewModel(for: .userNotFound)
    }
    
    func didInvalidateCurrentUser() {
        clearTweetsStopLoadingAndSetViewModel(for: .empty)
    }
    
    private func clearTweetsStopLoadingAndSetViewModel(for status: TimelineStatus) {
        stopLoadingAndSetViewModel(for: status)
        view?.clearTweetViewModels()
    }
}

private enum TimelineStatus {
    case empty
    case filled
    case privateUser
    case userNotFound
    
    var viewModel: TimelineViewModel {
        switch self {
        case .empty:
            return TimelineViewModel(message: "Type user's screen name to view tweets",
                                     image: UIImage(named: "email"),
                                     color: UIColor.lightGray)
        case .filled:
            return TimelineViewModel(message: nil, image: nil, color: UIColor.white)
        case .privateUser:
            return TimelineViewModel(message: "Private account",
                                     image: UIImage(named: "lock"),
                                     color: UIColor.gray)
        case .userNotFound:
            return TimelineViewModel(message: "User not found",
                                     image: UIImage(named: "mood_bad"),
                                     color: UIColor.orange)
        }
    }
}
