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

protocol TimelineWorker {
    func fetchTweets(after last: Tweet?, for user: User, _ completion: ([Tweet]?) -> Void)
    func cancelFetch()
}

protocol TimelineInteractor {
    func retrieveInitialTweets(for user: User)
    func retrieveMoreTweets()
    func cancelPendingTasks()
    init(with delegate: TimelineInteractorDelegate?)
}

class TimelineInteractorImpl: TimelineInteractor {
    weak var delegate: TimelineInteractorDelegate?
    private var tweets = [Tweet]()
    private var user: User?
    private var scheduleMoreWorkAfterCompletion = false
    
    private lazy var workerChainManager = ChainManager<TimelineWorker, (User, [Tweet])>(
        with: [MockTimelineWorker()],
        onEachStart: { [weak self] worker, params in
            self?.start(worker, with: params)
        },
        onStopCurrent: { $0.cancelFetch() }
    )
    
    required init(with delegate: TimelineInteractorDelegate?) {
        self.delegate = delegate
    }
    
    func retrieveInitialTweets(for user: User) {
        self.user = user
        tweets.removeAll()
        cancelPendingTasks()
        retrieveMoreTweets()
    }
    
    func retrieveMoreTweets() {
        guard let user = user else { return }
        guard !workerChainManager.isRunning else {
            scheduleMoreWorkAfterCompletion = true
            return
        }
        let tweets = self.tweets
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.workerChainManager.begin(with: (user, tweets))
        }
    }
    
    private func start(_ worker: TimelineWorker, with params: (user: User, tweets: [Tweet])) {
        worker.fetchTweets(after: params.tweets.first, for: params.user) { [weak self] results in
            guard let results = results else {
                self?.workerChainManager.startNext(with: params)
                return
            }
            self?.workerChainManager.stop()
            
            self?.tweets.append(contentsOf: results)
            
            DispatchQueue.main.async {
                self?.delegate?.didRetrieveTweets(results)
            }
            
            if (self?.scheduleMoreWorkAfterCompletion ?? false) {
                self?.retrieveMoreTweets()
            }
        }
    }
    
    func cancelPendingTasks() {
        workerChainManager.stop()
    }
}
