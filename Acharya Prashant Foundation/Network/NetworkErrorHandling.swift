//
//  NetworkErrorHandling.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import Foundation

typealias HttpStatusCode = Int

typealias NewResultHandler<T> = (_ result: T?, _ statusCode: HttpStatusCode?, _ error: DataError?) -> Void

enum DataSuccess {
    case success(Data?, HttpStatusCode) // status code in range of 200 ... 299
}

enum DataError: Error {
    case invalidResponse(Data?, HttpStatusCode) // status code in range of 200 ... 299
    
    case invalidURL
    case internet
    case invalidData(HttpStatusCode, Error?)
    case network(Error?)
    case decoding(Error?)
    case unknown(Error?)
    case error(String?)
    
    var errorMessage: String? {
        switch self {
        case .invalidResponse:
            return "invalid Response"
        case .invalidURL:
            return "invalid URL"
        case .internet:
            return "No Internet"
        case .invalidData(_, let error):
            return error?.localizedDescription ?? "Invalid Data Error"
        case .network(let error):
            return error?.localizedDescription ?? "Network Error"
        case .decoding(let error):
            return error?.localizedDescription ?? "Decoding Data Error"
        case .unknown(let error):
            return error?.localizedDescription ?? "Unknown Error"
        case .error(let message):
            return message ?? "Unknown Error"
        }
    }
}
