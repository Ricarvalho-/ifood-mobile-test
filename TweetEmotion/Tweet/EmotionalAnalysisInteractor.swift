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

protocol EmotionalAnalysisWorker {
    func fetchAnalysis(for text: String, completion: @escaping (EmotionalAnalysisResult?) -> Void)
    func cancelFetch()
}

protocol EmotionalAnalysisInteractor {
    func retrieveEmotionalAnalysis(for text: String)
    func cancelPendingTasks()
    init(with delegate: EmotionalAnalysisInteractorDelegate?)
}

class EmotionalAnalysisInteractorImpl: EmotionalAnalysisInteractor {
    weak var delegate: EmotionalAnalysisInteractorDelegate?
    
    private lazy var workerChainManager = ChainManager<EmotionalAnalysisWorker, String>(
        with: [GoogleAPIEmotionalAnalysisWorker()],
        onEachStart: { [weak self] worker, text in
            self?.start(worker, with: text)
        },
        onStopCurrent: { $0.cancelFetch() }
    )
    
    required init(with delegate: EmotionalAnalysisInteractorDelegate?) {
        self.delegate = delegate
    }
    
    func retrieveEmotionalAnalysis(for text: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.workerChainManager.begin(with: text)
        }
    }
    
    private func start(_ worker: EmotionalAnalysisWorker, with text: String) {
        worker.fetchAnalysis(for: text) { [weak self] result in
            guard let result = result else {
                if !(self?.workerChainManager.startNext(with: text) ?? false) {
                    self?.workerChainManager.begin(with: text)
                }
                return
            }
            self?.workerChainManager.stop()
            DispatchQueue.main.async {
                self?.delegate?.didRetrieveEmotionalAnalysis(result: result)
            }
        }
    }
    
    func cancelPendingTasks() {
        workerChainManager.stop()
    }
}

enum EmotionalAnalysisResult {
    case positive
    case neutral
    case negative
    case mixed
}
