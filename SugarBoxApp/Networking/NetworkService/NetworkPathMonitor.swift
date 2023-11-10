//
//  NetworkPathMonitor.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation
import Network

// MARK: - NetworkPathMonitor
/// A utility class for monitoring network connectivity using `NWPathMonitor`.
class NetworkPathMonitor {
    
    /// Checks for internet connection using `NWPathMonitor`.
    ///
    /// - Parameter completion: A closure to be called upon determining the internet connection status.
    ///   - isConnected: A boolean value indicating whether the device has an active internet connection.
    static func checkInternetConnectivity(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
        }
        monitor.start(queue: .main)
    }
}
