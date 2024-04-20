//
//  DashboardEndPoint.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 15/04/24.
//

import Foundation

enum DashboardEndPoint {
    case feed(_ limit: Int)
}

extension DashboardEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .feed(let limit):
            return "/api/v2/content/misc/media-coverages?limit=\(limit)"
        }
    }
    
    var method: HTTPMethods { .get }
}
