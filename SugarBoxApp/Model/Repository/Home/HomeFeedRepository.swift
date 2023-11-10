//
//  HomeFeedManager.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation

// MARK: - HomeFeedRepositoryError
/// Enum representing errors that may occur in the HomeFeedRepository.
enum HomeFeedRepositoryError: Error {
    
    /// An unknown or unexpected error.
    case unknown
    
    /// Indicates a lack of internet connectivity.
    case noInternet
    
    /// Initializes a HomeFeedRepositoryError based on a NetworkServiceError.
    ///
    /// - Parameter error: The NetworkServiceError to map to a HomeFeedRepositoryError.
    init(error: NetworkServiceError) {
        switch error {
        case .noInternet:
            self = .noInternet
        default:
            self = .unknown
        }
    }
}

// MARK: - HomeFeedRepository
/// Repository responsible for deciding the source for fetching home feeds.
///
/// Use the method `fetchHomeFeeds` to fetch home feeds.
final class HomeFeedRepository {
    
    // MARK: Properties
    
    /// The last network request made by the repository.
    private var lastRequest: NetworkService<HomeFeedsResponse>!
    
    // MARK: Methods
    
    /// Fetches home feeds based on specified page and limit.
    ///
    /// - Parameters:
    ///   - page: The page number for fetching home feeds.
    ///   - limit: The number of items to be fetched for a page.
    ///   - completion: The result of the fetch operation, either success or failure.
    func fetchHomeFeeds(page: Int, limit: Int, completion: @escaping (Result<HomeFeedsResponse, HomeFeedRepositoryError>) -> Void) {
        fetchHomeFeedsFromNetwork(page: page, limit: limit, completion: completion)
    }
}

//MARK: - Fetch from Network
private extension HomeFeedRepository {
    
    /// Fetches home feeds from the network.
    ///
    /// - Parameters:
    ///   - page: The page number for fetching home feeds.
    ///   - limit: The number of items to be fetched for a page.
    ///   - completion: The result of the fetch operation, either success or failure.
    private func fetchHomeFeedsFromNetwork(page: Int, limit: Int, completion: @escaping (Result<HomeFeedsResponse, HomeFeedRepositoryError>) -> Void) {
        
        let request = NetworkService<HomeFeedsResponse>(type: .fetchHomeFeeds(page: page, limit: limit), completion: { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.init(error: error)))
            }
        })
        
        if let lastRequest = lastRequest {
            request.addDependency(lastRequest)
        }
        
        request.resume()
        lastRequest = request
    }
}
