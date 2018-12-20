//
//  UserViewModel.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 19/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

protocol UserViewModel {
    var name: String { get }
    var verified: Bool { get }
    var profileImageURL: URL { get }
}
