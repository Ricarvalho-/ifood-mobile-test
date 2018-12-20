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
    func setUserViewModel(_: UserViewModel)
    func clearUserViewModel()
}

protocol UserSearchDelegate { // TimelinePresenter
    func didUpdateToPrivateUser()
    func didInvalidateCurrentUser()
    func didUpdateToNotFoundUser()
}

protocol UserSearchPresenter { // init from TimelineViewController, pass SearchView and TimelinePresenter
    func didChangeSearchTerm(_ searchTerm: String)
    init(with view: UserSearchView, delegate: UserSearchDelegate?) // weak
}
