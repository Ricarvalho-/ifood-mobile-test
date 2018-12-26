//
//  InMemoryCacheEmotionalAnalysisWorker.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 26/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

class InMemoryCacheEmotionalAnalysisWorker: EmotionalAnalysisWorker, EmotionalAnalysisCacheWorker {
    private static var resultRepo = [String: EmotionalAnalysisResult]()
    private static var orderedKeys = [String]()
    
    func fetchAnalysis(for text: String, completion: @escaping (EmotionalAnalysisResult?) -> Void) {
        completion(InMemoryCacheEmotionalAnalysisWorker.resultRepo[text])
    }
    
    func cancelFetch() {
        
    }
    
    func cacheAnalysis(result: EmotionalAnalysisResult, for text: String) {
        if InMemoryCacheEmotionalAnalysisWorker.resultRepo.count >= 1000 {
            InMemoryCacheEmotionalAnalysisWorker.resultRepo.remove(at: InMemoryCacheEmotionalAnalysisWorker.resultRepo.startIndex)
        }
        InMemoryCacheEmotionalAnalysisWorker.resultRepo[text] = result
    }
}
