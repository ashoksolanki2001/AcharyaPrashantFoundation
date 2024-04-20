//
//  ImageLoader.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 18/04/24.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
        
    var mediaCoverageList: FeedListModel?

    let memoryCache = NSCache<NSString, UIImage>()
    let diskCacheHelper = ImageCacheHelper()
    let imageDownloader = ImageDownloader()

    // Function to load image asynchronously with memory and disk caching
    func loadImage(withURL url: URL, setPriority priority: DownloadPriority, completion: @escaping (Result<UIImage, Error>) -> Void) {
        self.loadImageLocal(withURL: url, setPriority: priority) { image in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
    }
        
    func loadImageLocal(withURL url: URL, setPriority priority: DownloadPriority, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Check if the image is already in the memory cache
        if let cachedImage = self.memoryCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        // Load the image from disk cache if available
        if let diskImage = diskCacheHelper.getImageFromDiskCache(forURL: url) {
            self.memoryCache.setObject(diskImage, forKey: url.absoluteString as NSString)
            completion(.success(diskImage))
            return
        }
        
        // If the image is not found in memory or disk cache, initiate an asynchronous download
        self.downloadFromServer(url, setPriority: priority, completion)
    }
    
    func downloadFromServer(_ url: URL, setPriority priority: DownloadPriority, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        imageDownloader.downloadImage(withURL: url, setPriority: priority) { image, error in
            if let image {
                
                // Store image in memory cache
                self.memoryCache.setObject(image, forKey: url.absoluteString as NSString)
                // Store image in disk cache
                self.diskCacheHelper.saveImageToDiskCache(image, forURL: url)
                completion(.success(image))
            } else if let error {
                
                print("Unable to download pictures: ", error)
                completion(.failure(error))
            }
        }
        
    }
    
    func clearMemoryCache() {
        
        self.memoryCache.removeAllObjects()
    }
}

extension ImageLoader {
    func getImageUrl(at indexPath: IndexPath) -> URL? {
        if let imageModel = self.mediaCoverageList?[indexPath.item], let imagePath = imageModel.thumbnail?.bestQualityImage, let imageUrl = URL(string: imagePath) {
            return imageUrl
        }
        return nil
    }

    func setImageToCell(_ imageUrl: URL, _ collectionView: UICollectionView, _ indexPath: IndexPath, setPriority priority: DownloadPriority = .high) {
        loadImage(withURL: imageUrl, setPriority: priority) { result in
            // Check if the cell is still visible
            switch result {
            case .success(let image):
                if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                    if let cellToUpdate = collectionView.cellForItem(at: indexPath) as? FeedImageCell {
                        cellToUpdate.feedImgView.image = image
                    }
                }

            case .failure(let error):
                UIView.showToast(message: "Unable to download pictures: \(error.localizedDescription) for this URL \(imageUrl.absoluteString)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, willDisplay: Bool) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedImageCell", for: indexPath) as? FeedImageCell else {
            return UICollectionViewCell()
        }
        
        if willDisplay {
                        
            if let imageUrl = getImageUrl(at: indexPath) {
                setImageToCell(imageUrl, collectionView, indexPath, setPriority: .high)

            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let prefetchThreshold = 5 // Adjust this threshold as needed
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let prefetchIndexPaths = indexPaths.filter { indexPath in
            // Prefetch items that are within the prefetch threshold of visible content
            return visibleIndexPaths.contains { visibleIndexPath in
                abs(visibleIndexPath.item - indexPath.item) <= prefetchThreshold
            }
        }
        
        for indexPath in prefetchIndexPaths {
            
            if let imageUrl = getImageUrl(at: indexPath) {
                setImageToCell(imageUrl, collectionView, indexPath, setPriority: .prefetching)
                
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("cancelPrefetchingForItemsAt: ", indexPaths)
        for indexPath in indexPaths {
            if let imageUrl = getImageUrl(at: indexPath) {
                
                setImageToCell(imageUrl, collectionView, indexPath, setPriority: .prefetching)
            }
        }
    }
    
}
