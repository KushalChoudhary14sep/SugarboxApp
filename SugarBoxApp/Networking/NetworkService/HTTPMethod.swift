//
//  HTTPMethod.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation

// MARK: - HTTPMethod
/// Enum representing various HTTP methods supported for network requests.
enum HTTPMethod: String {
    
    /// Represents the HTTP GET method.
    case get = "GET"
    
    /// Represents the HTTP PUT method.
    case put = "PUT"
    
    /// Represents the HTTP POST method.
    case post = "POST"
    
    /// Represents the HTTP PATCH method.
    case patch = "PATCH"
    
    /// Represents the HTTP DELETE method.
    case delete = "DELETE"
}
