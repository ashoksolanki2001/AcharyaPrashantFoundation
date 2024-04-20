//
//  DashboardViewModel.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 15/04/24.
//

import Foundation

class DashboardViewModel { }

extension DashboardViewModel {
    func getFeeds(_ handler: @escaping (FeedListModel?) -> Void) {
        
        APIManager.shared.request(modelType: FeedListModel.self, type: DashboardEndPoint.feed(100)) { result, statusCode, error in
            
            if let error, let _ = error.errorMessage {
                handler(nil)
            }
            else if let result {
                handler(result)
            } else {
                handler([])
            }

        }
    }
}
