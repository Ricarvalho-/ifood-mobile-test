//
//  TweetTableViewCell.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 21/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell, TweetCell, TweetDetailView {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet var detailedViews: [UIView]!
    
    lazy var presenter = TweetDetailPresenterImpl(with: self)
    
    var tweetViewModel: TweetViewModel? {
        didSet {
            contentLabel.text = tweetViewModel?.text
            favoritesLabel.text = String(tweetViewModel?.favorites ?? 0)
            retweetsLabel.text = String(tweetViewModel?.retweets ?? 0)
            dateLabel.text = tweetViewModel?.date
            
            switch tweetViewModel?.emotionalStatus ?? TweetEmotionalStatus.none {
            case .positive:
                cardContainerView.backgroundColor = UIColor.yellow
            case .neutral:
                cardContainerView.backgroundColor = UIColor.lightGray
            case .negative:
                cardContainerView.backgroundColor = UIColor.blue
            default:
                cardContainerView.backgroundColor = UIColor.groupTableViewBackground
            }
        }
    }
    
    var detailed: Bool? {
        didSet {
            if detailed ?? false {
                presenter.retrieveTweetEmotionalStatus()
            }
            for view in detailedViews {
                view.isHidden = !(detailed ?? false)
            }
        }
    }
}
