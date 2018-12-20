//
//  TimelineViewModel.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 19/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import UIKit

struct TimelineViewModel {
    let message: String?
    let image: UIImage?
    let color: UIColor?
}

/*
enum TimelineStatus {
    case empty
    case filled
    case privateUser
    case userNotFound
    
    func viewModel() -> TimelineViewModel {
        switch self {
        case .empty:
            return TimelineViewModel(message: <#T##String#>, image: <#T##UIImage#>, color: UIColor.lightGray)
        case .filled:
            return TimelineViewModel(message: nil, image: nil, color: UIColor.white)
        case .privateUser:
            return TimelineViewModel(message: <#T##String#>, image: <#T##UIImage#>, color: UIColor.gray)
        case .userNotFound:
            return TimelineViewModel(message: <#T##String#>, image: <#T##UIImage#>, color: UIColor.orange)
        }
    }
}
*/
