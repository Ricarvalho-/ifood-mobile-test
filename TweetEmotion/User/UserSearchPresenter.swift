//
//  UserSearchPresenter.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 19/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

protocol UserSearchView: class {
    func startUserLoading()
    func stopUserLoading()
    func setUserViewModel(_ viewModel: UserViewModel)
    func clearUserViewModel()
}

protocol UserSearchDelegate: class {
    func didUpdateToValidUser(_ user: User)
    func didUpdateToPrivateUser()
    func didUpdateToNotFoundUser()
    func didInvalidateCurrentUser()
}

protocol UserSearchPresenter {
    func didChangeSearchTerm(_ searchTerm: String)
    init(with view: UserSearchView, delegate: UserSearchDelegate?)
}

class UserSearchPresenterImpl: UserSearchPresenter, UserSearchInteractorDelegate {
    weak var view: UserSearchView?
    weak var delegate: UserSearchDelegate?
    private lazy var interactor = UserSearchInteractorImpl(with: self)
    private var schedulledTimer: Timer?
    
    required init(with view: UserSearchView, delegate: UserSearchDelegate?) {
        self.view = view
        self.delegate = delegate
    }
    
    func didChangeSearchTerm(_ searchTerm: String) {
        scheduleNewSearch(searchTerm)
        view?.stopUserLoading()
        view?.clearUserViewModel()
        interactor.cancelPendingTasks()
        delegate?.didInvalidateCurrentUser()
    }
    
    private func scheduleNewSearch(_ term: String) {
        schedulledTimer?.invalidate()
        guard term.count > 0 else { return }
        
        schedulledTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.didElapsedDelayToPerform(search: term)
        })
    }
    
    private func didElapsedDelayToPerform(search: String) {
        view?.startUserLoading()
        interactor.retrieveUserInfo(for: search)
    }
    
    func didRetrieveUser(_ user: User) {
        view?.stopUserLoading()
        view?.setUserViewModel(ViewModel.init(from: user))
        if user.protected ?? false {
            delegate?.didUpdateToPrivateUser()
        } else {
            delegate?.didUpdateToValidUser(user)
        }
    }
    
    func didNotFoundUserToRetrieve() {
        view?.stopUserLoading()
        view?.clearUserViewModel()
        delegate?.didUpdateToNotFoundUser()
    }
    
    private struct ViewModel: UserViewModel {
        let name: String
        let verified: Bool
        let profileImageURL: URL?
        
        init(from user: User) {
            name = user.name ?? ""
            verified = user.verified ?? false
            if let url = user.profileImageURL {
                profileImageURL = URL(string: url)
            } else {
                profileImageURL = nil
            }
        }
    }
}
