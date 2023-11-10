//
//  APICollection.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation

// MARK: - APICollection
/// Enum representing various API endpoints for network requests.
/// Add cases for different network requests and provide the request body or query parameters as input parameters for each case.
enum APICollection {
    
    case fetchHomeFeeds(page: Int, limit: Int)
    
    // MARK: Properties
    
    /// The base URL for the network request endpoint.
    var baseURL: String {
        switch self {
        default:
            return "https://apigw.sboxdc.com"
        }
    }
    
    /// The path of the network request endpoint.
    var path: String {
        switch self {
        case .fetchHomeFeeds:
            return "/ecm/v2/super/feeds/zee5-home/details"
        }
    }
    
    /// The HTTP method for the network request.
    var method: HTTPMethod {
        switch self {
        case .fetchHomeFeeds:
            return .get
        }
    }
    
    /// The headers to be set for the network request.
    var headers: [String: String] {
        switch self {
        default:
            return [:]
        }
    }
}
