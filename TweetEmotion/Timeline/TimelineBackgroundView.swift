//
//  TimelineBackgroundView.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 21/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import UIKit

class TimelineBackgroundView: UIView, TimelineEmptyView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    var timelineViewModel: TimelineViewModel? {
        didSet {
            imageView.image = timelineViewModel?.image
            textLabel.text = timelineViewModel?.message
            backgroundColor = timelineViewModel?.color
        }
    }
}
