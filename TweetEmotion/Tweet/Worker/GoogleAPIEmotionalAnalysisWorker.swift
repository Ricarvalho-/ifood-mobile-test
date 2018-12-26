//
//  GoogleAPIEmotionalAnalysisWorker.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 25/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation
import Alamofire

class GoogleAPIEmotionalAnalysisWorker: EmotionalAnalysisWorker {
    private var request: DataRequest?
    private var canceled: Bool = false
    
    func fetchAnalysis(for text: String, completion: @escaping (EmotionalAnalysisResult?) -> Void) {
        canceled = false
        let baseURL = "https://language.googleapis.com"
        let api = "/v1/documents:analyzeSentiment"
        let apiKey = "AIzaSyDRLCa5W-HRjqirjhENLF8xb57YCkAic9U"
        let params = "?fields=documentSentiment&key=\(apiKey)"
        let url = baseURL + api + params
        let headers = ["Content-Type": "application/json"]
        let body: Parameters = [
            "encodingType": "UTF8",
            "document": [
                "type": "PLAIN_TEXT",
                "content": text
            ]
        ]
        
        request = Alamofire.request(url,
                                    method: .post,
                                    parameters: body,
                                    encoding: JSONEncoding.default,
                                    headers: headers)
            .validate().responseData { [weak self] response in
                guard !(self?.canceled ?? true) else { return }
                switch response.result {
                case .success(let value):
                    completion(try? JSONDecoder().decode(GoogleSentimentAnalysisResult.self,
                                                         from: value).emotionalResult)
                    break
                case .failure:
                    completion(nil)
                    break
                }
        }
    }
    
    func cancelFetch() {
        canceled = true
        request?.cancel()
    }
}

private struct GoogleSentimentAnalysisResult: Codable {
    var documentSentiment: Sentiment
    
    var emotionalResult: EmotionalAnalysisResult {
        switch documentSentiment.score {
        case _ where documentSentiment.score < -0.25:
            return .negative
        case _ where documentSentiment.score > 0.25:
            return .positive
        default:
            return .neutral
        }
    }
    
    class Sentiment: Codable {
        let magnitude: Float
        let score: Float
    }
}
