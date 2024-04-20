//
//  EndPointType.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import Foundation

let SERVER_BASE_URL           = "https://acharyaprashant.org"

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

extension EndPointType {
    var baseURL: String {
        return SERVER_BASE_URL
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var body: Encodable? {
        return nil
    }
    
    var headers: [String : String]? {
        let headers = [
            "Content-Type": "application/json"
        ]
        
        return headers
    }
}

