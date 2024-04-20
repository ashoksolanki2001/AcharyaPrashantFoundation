//
//  NetworkReachability.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import Foundation
import Network

class NetworkReachability {

    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
//            debugPrint("NetworkReachability - Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            debugPrint("NetworkReachability - unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            debugPrint("NetworkReachability - requiresConnection")
        }
    }

    let backgroudQueue = DispatchQueue.global(qos: .background)

    static let shared = NetworkReachability()

    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }

    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
    
}
