//
//  NetworkService.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation

// MARK: - NetworkService
/// A generic class for handling network requests.
final class NetworkService<T: Codable>: AsyncOperation {
    
    // MARK: Properties
    
    /// The type of API collection for the network request.
    var type: APICollection
    
    /// The completion block to be called after the network request finishes.
    var completion: (Result<T, NetworkServiceError>) -> Void
    
    // MARK: Initialization
    
    /// Initializes a network service instance with a specified API collection type and completion block.
    ///
    /// - Parameters:
    ///   - type: The type of API collection representing the network request.
    ///   - completion: The completion block to be called with the result of the network request.
    init(type: APICollection, completion: @escaping (Result<T, NetworkServiceError>) -> Void) {
        self.type = type
        self.completion = completion
    }
    
    // MARK: Task Management
    
    /// The URLSessionDataTask associated with the network request.
    var task: URLSessionDataTask?
    
    /// Cancels the network request.
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
    
    /// Performs the network request when the operation is executed.
    override func main() {
        let networkCompletion: (Bool) -> Void = { [weak self] flag in
            guard let self = self else { return }
            switch flag {
            case true:
                switch self.type {
                case .fetchHomeFeeds(let page, let limit):
                    let queryParam: [String: Any] = ["page": page, "perPage": limit]
                    self.request(type: self.type, queryParam: queryParam, completion: self.completion)
                }
            case false:
                self.completion(.failure(.noInternet))
                self.finish()
            }
        }
        NetworkPathMonitor.checkInternetConnectivity(completion: networkCompletion)
    }
}

// MARK: - NetworkService - resume
extension NetworkService {
    
    /// Resumes the network service by adding it to the specified operation queue.
    ///
    /// - Parameter operationQueue: The operation queue on which to add the network service.
    
    func resume(operationQueue: OperationQueue = AsyncOperation.defaultOperationQueue) {
        operationQueue.addOperation(self)
    }
}

// MARK: - NetworkService - request
private extension NetworkService {
    
    /// Makes a network request based on the provided API collection type.
    ///
    /// - Parameters:
    ///   - type: The type of API collection representing the network request.
    ///   - queryParam: Query parameters for the request (optional).
    ///   - requestBody: Request body (optional).
    ///   - completion: Completion block with results (Codable or NetworkServiceError).
    
    private func request(type: APICollection, queryParam: [String:Any]? = nil, requestBody: Codable? = nil, completion: @escaping (Result<T, NetworkServiceError>) -> Void) {
        
        var urlComponents = URLComponents(string: type.baseURL) // Setting base url
        
        urlComponents = handleQueryParams(urlComponents: urlComponents, queryParam: queryParam) // Handling Query Params
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            self.finish()
            return
        }
        
        var request = URLRequest(url: url.appending(path: type.path)) // Setting Path
        
        request.httpMethod = type.method.rawValue // Setting Request Method
        
        type.headers.forEach { header in
            request.setValue(header.key, forHTTPHeaderField: header.value)
        } // Setting Headers
        
        if let requestBody = requestBody {
            let result = handleRequestBody(request: request, requestBody: requestBody)
            switch result {
            case .success(let urlRequest):
                request = urlRequest
            case .failure(let error):
                completion(.failure(error))
                self.finish()
                return
            }
        } // Handling Request Body
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error: error)))
                return
            }
            
            if response != nil, let data = data {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(response))
                    self.finish()
                } catch {
                    completion(.failure(.decodingError))
                    self.finish()
                }
            } else {
                completion(.failure(.unknown))
                self.finish()
            }
        } // Performing Network Request
        
        task?.resume()
    }
}

// MARK: - NetworkService - Handle Query Param
private extension NetworkService {
    
    /// Handles query parameters for the network request.
    ///
    /// - Parameters:
    ///   - urlComponents: The URL components representing the network request.
    ///   - queryParam: Query parameters for the request.
    /// - Returns: The updated URL components with query parameters.
    private func handleQueryParams(urlComponents: URLComponents?, queryParam: [String:Any]?) -> URLComponents? {
        var components: URLComponents? = urlComponents
        if let queryParam = queryParam {
            var queryItems: [URLQueryItem] = []
            queryParam.forEach { param in
                let query = URLQueryItem(name: param.key, value: "\(param.value)")
                queryItems.append(query)
            }
            components?.queryItems = queryItems
        }
        return components
    }
}

// MARK: - NetworkService - Handle Request Body
private extension NetworkService {
    
    /// Handles the HTTP request body for the network request.
    ///
    /// - Parameters:
    ///   - request: The original URLRequest.
    ///   - requestBody: The Codable object representing the request body.
    /// - Returns: The updated URLRequest with the encoded request body.
    private func handleRequestBody(request: URLRequest, requestBody: Codable) -> Result<URLRequest, NetworkServiceError> {
        var newRequest = request
        do {
            let encoder = JSONEncoder()
            newRequest.httpBody = try encoder.encode(requestBody)
            return .success(newRequest)
        } catch {
            return .failure(.encodingError)
        }
    }
}
