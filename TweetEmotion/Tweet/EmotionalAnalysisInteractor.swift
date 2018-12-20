//
//  EmotionalAnalysisInteractor.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 20/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

protocol EmotionalAnalysisInteractorDelegate: class {
    func didRetrieveEmotionalAnalysis(result: EmotionalAnalysisResult)
}

protocol EmotionalAnalysisInteractor {
    func retrieveEmotionalAnalysis(for text: String)
    init(with delegate: EmotionalAnalysisInteractorDelegate) // weak
}

enum EmotionalAnalysisResult {
    case positive
    case neutral
    case negative
    case mixed
}
