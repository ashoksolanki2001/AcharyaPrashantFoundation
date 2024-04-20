//
//  ApiManager.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import Foundation

final class APIManager {
    
    static let shared = APIManager(networkHandler: NetworkHandlerURLSession(), responseHandler: ResponseHandlerURLSession())
    
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler

    init(networkHandler: NetworkHandler, responseHandler: ResponseHandler) {
        self.networkHandler = networkHandler
        self.responseHandler = responseHandler
    }
}

extension APIManager {
    @discardableResult
    func request<T: Decodable>(
        modelType: T.Type,
        type: EndPointType,
        showProgressHUD: Bool = true,
        completion: @escaping NewResultHandler<T>
    ) -> URLRequest? {
        
        guard let url = type.url else {
            completion(nil, 404, .invalidURL)
            return nil
        }
        
        guard NetworkReachability.shared.isNetworkAvailable() else {
            completion(nil, 503, .internet)
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue

        if let parameters = type.body {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }

        request.allHTTPHeaderFields = type.headers
        // Network Request - URL TO DATA
        
        if showProgressHUD {
            ProgressLoader.shared.startLoading()
        }
        
        func callCompletion(_ result: T?, _ statusCode: HttpStatusCode?, _ error: DataError?) {
                        
            DispatchQueue.main.async {
                completion(result, statusCode, error)
                if showProgressHUD {
                    ProgressLoader.shared.stopLoading()
                }
            }

        }
        
        networkHandler.requestDataAPI(urlRequest: request) { result in
            switch result {
            case .success(let response):

                switch response {
                case .success(let data, let statusCode):
                    if let data = data {

                        let responsedataerror = self.responseHandler.parseResponseDecode(data: data, modelType: modelType)
                        callCompletion(responsedataerror.model, statusCode, nil)
                    } else {
                        callCompletion(nil, statusCode, nil)
                    }
                }
            case .failure(let error):
                switch error {
                case .invalidResponse(let data, let statusCode):

                    if let data = data {
                        
                        let responsedataerror = self.responseHandler.parseResponseDecode(data: data, modelType: modelType)
                        callCompletion(responsedataerror.model, statusCode, DataError.error(responsedataerror.model.debugDescription))
                    } else {
                        callCompletion(nil, statusCode, error)
                    }
                default:
                    callCompletion(nil, nil, error)
                }
            }
        }
        return request
    }

}
extension APIManager {
    static func isValidHttp(code: HttpStatusCode?) -> Bool {
        guard let code, 200 ... 299 ~= code else {
            return false
        }
        return true
    }
}
