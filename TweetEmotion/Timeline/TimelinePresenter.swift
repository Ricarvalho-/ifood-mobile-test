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
    func addTweetViewModels(_ viewModels: [TweetViewModel])
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
        view?.startTimelineLoading()
        interactor?.retrieveMoreTweets()
    }
    
    func didRetrieveTweets(_ tweets: [Tweet]) {
        stopLoadingAndSetViewModel(for: .filled)
        view?.addTweetViewModels(tweets.map { ViewModel.init(from: $0) })
    }
    
    private func stopLoadingAndSetViewModel(for status: TimelineStatus) {
        view?.stopTimelineLoading()
//        view?.timelineViewModel = status.viewModel()
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
//        view?.timelineViewModel = TimelineStatus.empty.viewModel()
        interactor?.retrieveInitialTweets(for: user)
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
    
    /*
    func viewModel() -> TimelineViewModel {
        switch self {
        case .empty:
            return TimelineViewModel(message: <#T##String#>, image: <#T##UIImage#>, color: UIColor.lightGray)
        case .filled:
            return TimelineViewModel(message: nil, image: nil, color: UIColor.white)
        case .privateUser:
            return TimelineViewModel(message: <#T##String#>, image: <#T##UIImage#>, color: UIColor.gray)
        case .userNotFound:
            return TimelineViewModel(message: <#T##String#>, image: <#T##UIImage#>, color: UIColor.orange)
        }
    }
    */
}
