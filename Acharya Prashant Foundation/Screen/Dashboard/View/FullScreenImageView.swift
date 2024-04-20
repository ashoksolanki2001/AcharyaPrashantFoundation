//
//  FullScreenImageView.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import UIKit

class FullScreenImageView: UIViewController {

    @IBOutlet weak var feedImageView: UIImageView!
    
    var feedDetails: FeedDetailsElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = feedDetails?.title

        downloadImage(from: feedDetails)
    }
    
    @IBAction func clickOnNewsFeed(_ sender: UIButton) {
        guard let coverageURL = feedDetails?.coverageURL, let url = URL(string: coverageURL) else { return }
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CoverageViewController") as? CoverageViewController {
            controller.coverageUrl = url
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func downloadImage(from feedData: FeedDetailsElement?) {
        if let feedData, let basePath = feedData.thumbnail?.bestQualityImage, let imageUrl = URL(string: basePath) {
            
            ImageLoader.shared.loadImage(withURL: imageUrl, setPriority: .high) { [weak self] result in
                guard let self else {return}
                
                switch result {
                case .success(let image):
                    self.feedImageView.image = image

                case .failure(let error):
                    UIView.showToast(message: "Unable to download pictures: \(error.localizedDescription) for this URL \(imageUrl.absoluteString)")
                }
            }
        }
    }
}
