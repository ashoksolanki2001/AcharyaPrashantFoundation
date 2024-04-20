//
//  ImageCacheManager.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import UIKit

class ImageCacheHelper {
    
    private let fileManager = FileManager.default
    private let diskCacheDirectory: URL
    
    init() {
        
        // Get the caches directory URL
        let directoryPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheDirectory = directoryPath.appendingPathComponent("ImageCache")

        if let cachesDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            // Append a directory name to the caches directory URL
            let directoryName = "ImageCache"
            let directoryURL = cachesDirectoryURL.appendingPathComponent(directoryName)
            
            do {
                // Check if the directory already exists
                if !fileManager.fileExists(atPath: directoryURL.path) {
                    // Create the directory
                    try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                    print("Directory created at:", directoryURL.path)
                } else {
                    print("Directory already exists at:", directoryURL.path)
                }
            } catch {
                print("Error creating directory:", error.localizedDescription)
            }
        } else {
            print("Caches directory URL not found.")
        }
    }
    
    // Function to get image from disk cache
    func getImageFromDiskCache(forURL url: URL) -> UIImage? {
        let fileName = getFileName(formUrl: url)
        let filePath = diskCacheDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: filePath), let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    // Function to save image to disk cache
    func saveImageToDiskCache(_ image: UIImage, forURL url: URL) {
        let fileName = getFileName(formUrl: url)
        let filePath = diskCacheDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        do {
            try data.write(to: filePath)
        } catch {
            print(error)
        }
    }
    
    func clearDiskCache() {
        do {
            // Get all URLs of files in the folder
            let fileURLs = try fileManager.contentsOfDirectory(at: diskCacheDirectory, includingPropertiesForKeys: nil, options: [])
            
            // Iterate through the file URLs and remove each file
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error while removing files:", error.localizedDescription)
        }
    }
    
    func getFileName(formUrl url: URL) -> String {
        url.absoluteString.replacingOccurrences(of: "/", with: "")
    }
}
