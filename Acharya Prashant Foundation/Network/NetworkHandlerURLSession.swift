//
//  NetworkHandlerURLSession.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import Foundation
import Combine

protocol NetworkHandler {
    func requestDataAPI(
        urlRequest: URLRequest,
        completionHandler: @escaping (Result<DataSuccess, DataError>) -> Void
    )
    
    func validateResponse(_ urlResponse: URLResponse?) -> (success: Bool, statusCode: HttpStatusCode)
}

extension NetworkHandler {
    
    func validateResponse(_ urlResponse: URLResponse?) -> (success: Bool, statusCode: HttpStatusCode) {
        if let response = urlResponse as? HTTPURLResponse {
            guard APIManager.isValidHttp(code: response.statusCode) else {
                return (false, response.statusCode)
            }
            return (true, response.statusCode)
        }
        return (false, -1)
    }
}


class NetworkHandlerURLSession : NetworkHandler {
    private var cancellables = Set<AnyCancellable>()

    let urlSession: URLSession = {
        let urlSession = URLSession.shared
        urlSession.configuration.timeoutIntervalForRequest = 15
        return urlSession
    }()
    
    init() { }
    
    func requestDataAPI(
        urlRequest: URLRequest,
        completionHandler: @escaping (Result<DataSuccess, DataError>) -> Void
    ) {
        requestFuture(urlRequest: urlRequest).sink { completion in
            switch completion {
            case .failure(let err):
                print("Error is \(err.localizedDescription)")
                completionHandler(.failure(err))
            case .finished:
                print("Finished")
            }
        }
        receiveValue: { responseData in
            completionHandler(.success(responseData))
        }
        . store(in: &cancellables)
    }
        
    func requestFuture(urlRequest: URLRequest) -> Future<DataSuccess, DataError> {
        return Future<DataSuccess, DataError>() { [weak self] promise in
            guard let self else { return }
            var statusCode: HttpStatusCode = -1
            self.urlSession.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    let validationData = self.validateResponse(response)
                    statusCode = validationData.statusCode
                    guard validationData.success else {
                        throw DataError.invalidResponse(data, statusCode)
                    }
                    
                    return data
                }
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(DataError.decoding(decodingError)))
                        case let apiError as DataError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(DataError.unknown(error)))
                        }
                    }
                }, receiveValue: {
                    promise(.success(DataSuccess.success($0, statusCode)))
                })
                .store(in: &self.cancellables)
        }
    }
    
}
