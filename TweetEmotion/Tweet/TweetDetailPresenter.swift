//
//  TweetDetailPresenter.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 18/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

protocol TweetDetailView: class {
    var tweetViewModel: TweetViewModel? { get set }
}

protocol TweetDetailPresenter {
    func retrieveTweetEmotionalStatus()
    init(with view: TweetDetailView)
}

class TweetDetailPresenterImpl: TweetDetailPresenter, EmotionalAnalysisInteractorDelegate {
    weak var view: TweetDetailView?
    private lazy var interactor = EmotionalAnalysisInteractorImpl(with: self)
    
    required init(with view: TweetDetailView) {
        self.view = view
    }
    
    func retrieveTweetEmotionalStatus() {
        guard let viewModel = view?.tweetViewModel else { return }
        view?.tweetViewModel = ViewModel.init(with: viewModel, status: .loading)
        interactor.retrieveEmotionalAnalysis(for: viewModel.text)
    }
    
    func didRetrieveEmotionalAnalysis(result: EmotionalAnalysisResult) {
        guard let viewModel = view?.tweetViewModel else { return }
        view?.tweetViewModel = ViewModel.init(with: viewModel, analysisResult: result)
    }
    
    private struct ViewModel: TweetViewModel {
        let date, text: String
        let favorites, retweets: Int
        let emotionalStatus: TweetEmotionalStatus
        
        init(with viewModel: TweetViewModel, status: TweetEmotionalStatus) {
            date = viewModel.date
            text = viewModel.text
            favorites = viewModel.favorites
            retweets = viewModel.retweets
            emotionalStatus = status
        }
        
        init(with viewModel: TweetViewModel, analysisResult: EmotionalAnalysisResult) {
            var status: TweetEmotionalStatus
            switch analysisResult {
            case .positive:
                status = .positive
            case .negative:
                status = .negative
            case .neutral, .mixed:
                status = .neutral
            }
            self.init(with: viewModel, status: status)
        }
    }
}
