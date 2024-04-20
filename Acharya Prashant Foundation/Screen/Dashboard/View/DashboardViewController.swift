//
//  DashboardViewController.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 15/04/24.
//

import UIKit

class DashboardViewController: UICollectionViewController {
    
    var viewModel = DashboardViewModel()
    var imageLoader = ImageLoader.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Acharya Prashant Foundation"
        
        self.configCollectionView()
        self.getFeedListFromApi()
        self.addMenuButton()
    }
    
    fileprivate func getFeedListFromApi() {
        viewModel.getFeeds { [weak self] feeds in
            guard let self, let feeds else {return}
            self.imageLoader.mediaCoverageList = feeds
            self.collectionView.reloadData()
        }
    }

}

extension DashboardViewController {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if let collectionView = scrollView as? UICollectionView {
            self.imageLoader.resetDownloadingForVisibleCell(collectionView)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imageLoader.mediaCoverageList?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.imageLoader.collectionView(collectionView, cellForItemAt: indexPath, willDisplay: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        _ = self.imageLoader.collectionView(collectionView, cellForItemAt: indexPath, willDisplay: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let feedData = self.imageLoader.mediaCoverageList?[safe: indexPath.row] else { return }
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "FullScreenImageView") as? FullScreenImageView {
            controller.feedDetails = feedData
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension DashboardViewController: UICollectionViewDataSourcePrefetching {
            
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        self.imageLoader.collectionView(collectionView, prefetchItemsAt: indexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        self.imageLoader.collectionView(collectionView, cancelPrefetchingForItemsAt: indexPaths)
    }
        
}

extension DashboardViewController {
    
    func configCollectionView() {
        self.collectionView.register(FeedImageCell.self, forCellWithReuseIdentifier: "feedImageCell")
        let layout = SquareColumnFlowLayout()
        self.collectionView.collectionViewLayout = layout
        
        self.collectionView.register(UINib(nibName: "FeedImageCell", bundle: nil), forCellWithReuseIdentifier: "feedImageCell")
        
        self.collectionView?.prefetchDataSource = self
    }
    
    func addMenuButton() {
        let menuButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(menuButtonTapped))
        self.navigationItem.rightBarButtonItem = menuButton
    }

    @objc func menuButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Add actions
        let option1Action = UIAlertAction(title: "Clear Memory Cache", style: .default) { _ in
            
            ImageLoader.shared.clearMemoryCache()
        }
        let option2Action = UIAlertAction(title: "Clear Disk Cache", style: .default) { _ in
            
            ImageLoader.shared.diskCacheHelper.clearDiskCache()
        }
        let option3Action = UIAlertAction(title: "Refresh Feeds", style: .default) { _ in
            
            self.getFeedListFromApi()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        // Add actions to the alert controller
        alertController.addAction(option1Action)
        alertController.addAction(option2Action)
        alertController.addAction(option3Action)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

}
