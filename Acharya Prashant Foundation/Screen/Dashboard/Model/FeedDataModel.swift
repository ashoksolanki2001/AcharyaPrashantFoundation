//
//  FeedDataModel.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 15/04/24.
//

import Foundation

typealias FeedListModel = [FeedDetailsElement]

// MARK: - FeedDetailsModelElement
struct FeedDetailsElement: Decodable {
    
    let id, title: String?
    let language: String?
    let thumbnail: ThumbnailElement?
    let mediaType: Int?
    let coverageURL: String?
    let publishedAt, publishedBy: String?
    let backupDetails: BackupDetailsElement?
    
}

// MARK: - BackupDetails
struct BackupDetailsElement: Decodable {
    
    let pdfLink: String?
    let screenshotURL: String?
    
}

// MARK: - Thumbnail
struct ThumbnailElement: Decodable {
    
    let id: String?
    let version: Int?
    let domain: String?
    let basePath: String?
    let key: String?
    let qualities: [Int]?
    let aspectRatio: Int?
    
    func getImageUrl(with qualitie: Int) -> String? {
        guard let domain, let basePath, let key else { return nil }
        return "\(domain)/\(basePath)/\(qualitie)/\(key)"
    }
        
    var thumbnailImage: String? {
        guard let lowestQualitie = qualities?.sorted(by: >).last else { return nil }
        return getImageUrl(with: lowestQualitie)
    }
    
    var bestQualityImage: String? {
        guard let bestQualitie = qualities?.sorted(by: <).last else { return nil }
        return getImageUrl(with: bestQualitie)
    }
    
}
