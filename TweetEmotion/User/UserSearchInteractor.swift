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

protocol UserSearchInteractor {
    func retrieveUserInfo(for screenName: String)
    init(with delegate: UserSearchInteractorDelegate?) // weak
}
