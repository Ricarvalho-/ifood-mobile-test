//
//  MockEmotionalAnalysisWorker.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 20/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

class MockEmotionalAnalysisWorker: EmotionalAnalysisWorker {
    func fetchAnalysis(for text: String, _ completion: (EmotionalAnalysisResult?) -> Void) {
        switch text.count % 4 {
        case 0:
            completion(.neutral)
        case 1:
            completion(.negative)
        case 2:
            completion(.positive)
        default:
            completion(.mixed)
        }
    }
    
    func cancelFetch() {
        
    }
}
