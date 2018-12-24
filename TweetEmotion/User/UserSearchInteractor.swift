//
//  UserSearchInteractor.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 19/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

protocol UserSearchInteractorDelegate: class {
    func didRetrieveUser(_ user: User)
    func didNotFoundUserToRetrieve()
}

protocol UserSearchWorker {
    func fetchUser(with screenName: String, _ completion: (User?) -> Void)
    func cancelFetch()
}

protocol UserSearchInteractor {
    func retrieveUserInfo(for screenName: String)
    func cancelPendingTasks()
    init(with delegate: UserSearchInteractorDelegate?)
}

class UserSearchInteractorImpl: UserSearchInteractor {
    weak var delegate: UserSearchInteractorDelegate?
    
    private lazy var workerChainManager = ChainManager<UserSearchWorker, String>(
        with: [MockUserSearchWorker()],
        onEachStart: { [weak self] worker, screenName in
            self?.start(worker, with: screenName)
        },
        onStopCurrent: { $0.cancelFetch() }
    )
    
    required init(with delegate: UserSearchInteractorDelegate?) {
        self.delegate = delegate
    }
    
    func retrieveUserInfo(for screenName: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.workerChainManager.begin(with: screenName)
        }
    }
    
    private func start(_ worker: UserSearchWorker, with screenName: String) {
        worker.fetchUser(with: screenName) { [weak self] result in
            guard let result = result else {
                if !(self?.workerChainManager.startNext(with: screenName) ?? false) {
                    DispatchQueue.main.async {
                        self?.delegate?.didNotFoundUserToRetrieve()
                    }
                }
                return
            }
            self?.workerChainManager.stop()
            DispatchQueue.main.async {
                self?.delegate?.didRetrieveUser(result)
            }
        }
    }
    
    func cancelPendingTasks() {
        workerChainManager.stop()
    }
}
