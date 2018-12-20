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

protocol UserSearchPresenter {
    func didChangeSearchTerm(_ searchTerm: String)
    init(with view: UserSearchView) // weak
}
