//
//  NetworkServiceError.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation

// MARK: - NetworkServiceError
/// Enum representing different error scenarios that may occur during network requests.
enum NetworkServiceError: Error {
    
    /// Indicates an invalid URL for the network request.
    case invalidURL
    
    /// Indicates an error during decoding of the network response.
    case decodingError
    
    /// Indicates an error during encoding of the request body.
    case encodingError
    
    /// Indicates a general network error with an associated `Error` object.
    case networkError(error: Error)
    
    /// Indicates a lack of internet connectivity during the network request.
    case noInternet
    
    /// Indicates an unknown or unexpected error during the network request.
    case unknown
}
