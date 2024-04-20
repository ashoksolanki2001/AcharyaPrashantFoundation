//
//  ProgressLoader.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 19/04/24.
//

import UIKit

class ProgressLoader {
    static let shared = ProgressLoader()
    
    private var activityIndicator: UIActivityIndicatorView!

    private init() {
        // Create the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        
        // Find the appropriate window scene and its window
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                activityIndicator.center = window.center
                window.addSubview(activityIndicator)
            }
        }
        
        activityIndicator.hidesWhenStopped = true
    }

    // Function to start the activity indicator
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            // Optionally, you can disable user interaction while loading
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
//                    window.isUserInteractionEnabled = false
                }
            }
        }
    }

    // Function to stop the activity indicator
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            // Re-enable user interaction
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
//                    window.isUserInteractionEnabled = true
                }
            }
        }
    }
}


