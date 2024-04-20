//
//  ResponseHandlerURLSession.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import Foundation

protocol ResponseHandler {
    func parseResponseDecode<T: Decodable>(
        data: Data,
        modelType: T.Type
    ) -> (model: T?, error: Error?)
}

extension ResponseHandler {
    func parseResponseDecode<T: Decodable>(
        data: Data,
        modelType: T.Type
    ) -> (model: T?, error: Error?) {
        do {
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            return (userResponse, nil)
        } catch {
            return (nil, DataError.decoding(error))
        }
    }
}

class ResponseHandlerURLSession : ResponseHandler { }
