//
//  ImageOperationHandler.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 19/04/24.
//

import UIKit

enum DownloadPriority: Float {
    
    case high = 0
    case prefetching = 1
}

class ImageDownloader {
    
    private var session: URLSession!
    private var downloadTasks = [URL: URLSessionDataTask]()
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config)
    }
    
    func downloadImage(withURL url: URL, setPriority priority: DownloadPriority = .prefetching, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        if let task = downloadTasks[url] {
//            if task.priority != priority.rawValue {
//                print("priority change from: \(task.priority) to \(priority.rawValue)")
//            } else {
//                print("priority value is: \(task.priority)")
//            }
            // Another download is already in progress using the same URL. Just change downloading priority hear
            task.priority = priority.rawValue
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            defer {
                self.downloadTasks.removeValue(forKey: url)
            }

            guard let data = data, let image = UIImage(data: data) else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(image, nil)
        }
        
        task.priority = priority.rawValue
        task.resume()
        
        downloadTasks[url] = task
    }
    
    func pauseDownload(withURL url: URL) {
        if let task = downloadTasks[url] {
            task.suspend()
        }
    }
    
    func resumeDownload(withURL url: URL) {
        if let task = downloadTasks[url] {
            task.resume()
        }
    }
    
    func cancelDownload(withURL url: URL) {
        if let task = downloadTasks[url] {
            task.cancel()
            downloadTasks.removeValue(forKey: url)
        }
    }
    
    func updatePriority(forURL url: URL, priority: DownloadPriority) {
        if let task = downloadTasks[url] {
            task.priority = priority.rawValue
        }
    }
    
    func resetAllPriority() {
        for task in downloadTasks {
            
//            print("reset priority: \(task.value.priority)")
            task.value.priority = DownloadPriority.prefetching.rawValue
        }
    }

}
