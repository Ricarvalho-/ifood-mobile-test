//
//  UserSearchView.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 21/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import UIKit
import AlamofireImage

class UserSearchViewImpl: UIView, UserSearchView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var verifiedBadgeImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: UserSearchPresenter?
    
    @IBAction func textFieldValueDidChange(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        presenter?.didChangeSearchTerm(text)
    }
    
    func startUserLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopUserLoading() {
        activityIndicator.stopAnimating()
    }
    
    func setUserViewModel(_ viewModel: UserViewModel) {
        nameLabel.text = viewModel.name
        nameLabel.isHidden = false
        verifiedBadgeImageView.isHidden = !viewModel.verified
        profileImageView.isHidden = viewModel.profileImageURL == nil
        
        if let imageURL = viewModel.profileImageURL {
            profileImageView.af_setImage(withURL: imageURL,
                                         placeholderImage: UIImage(named: "account_circle"))
        }
    }
    
    func clearUserViewModel() {
        nameLabel.text = nil
        nameLabel.isHidden = true
        verifiedBadgeImageView.isHidden = true
        profileImageView.image = nil
        profileImageView.isHidden = true
        profileImageView.af_cancelImageRequest()
    }
}
