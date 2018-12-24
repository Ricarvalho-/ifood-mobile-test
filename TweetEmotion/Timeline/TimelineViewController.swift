//
//  TimelineViewController.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 21/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import UIKit

protocol TweetCell {
    var tweetViewModel: TweetViewModel? { get set }
    var detailed: Bool? { get set }
}

protocol TimelineEmptyView {
    var timelineViewModel: TimelineViewModel? { get set }
}

class TimelineViewController: UIViewController, TimelineView {
    @IBOutlet weak var userSearchView: UserSearchViewImpl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var emptyView: TimelineBackgroundView!
    
    private var viewModels = [(tweet: TweetViewModel, detailed: Bool)]()
    private lazy var presenter = TimelinePresenterImpl(with: self)
    var timelineViewModel: TimelineViewModel? {
        didSet {
            emptyView?.timelineViewModel = timelineViewModel
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userSearchView.presenter = UserSearchPresenterImpl(with: userSearchView, delegate: presenter)
        tableView.backgroundView = emptyView
    }
    
    func startTimelineLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopTimelineLoading() {
        activityIndicator.stopAnimating()
    }
    
    func addTweetViewModels(_ viewModels: [TweetViewModel]) {
        var indexPathsToAdd = [IndexPath]()
        for row in self.viewModels.count..<self.viewModels.count + viewModels.count {
            indexPathsToAdd.append(IndexPath(row: row, section: 0))
        }
        
        for viewModel in viewModels {
            self.viewModels.append((tweet: viewModel, detailed: false))
        }
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: indexPathsToAdd, with: .automatic)
        }, completion: nil)
    }
    
    func clearTweetViewModels() {
        self.viewModels.removeAll()
        self.tableView.reloadData()
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tweet") else {
            return UITableViewCell()
        }
        
        if var cell = cell as? TweetCell {
            cell.tweetViewModel = viewModels[indexPath.row].tweet
            cell.detailed = viewModels[indexPath.row].detailed
        }
        return cell
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModels[indexPath.row].detailed = !viewModels[indexPath.row].detailed
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModels.count - indexPath.row <= 5 else {
            if shouldCancelRetrieval() {
                presenter.cancelTweetsRetrieval()
            }
            return
        }
        presenter.loadMoreTweets()
    }
    
    private func shouldCancelRetrieval() -> Bool {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return true }
        return visibleIndexPaths.reduce(true) { previousResult, indexPath in
            previousResult && viewModels.count - indexPath.row > 5
        }
    }
}
