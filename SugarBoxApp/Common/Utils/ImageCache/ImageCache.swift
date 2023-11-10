//
//  ImageCache.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation
import UIKit

//MARK: - Enumeration to represent different expiration policies for cached images
fileprivate enum ExpirationPolicy {
    case never
    case forTimeInterval(time: TimeInterval)
}

//MARK: - ImageCache class to manage caching of images
class ImageCache {
    
    static let shared = ImageCache()
    private let memoryCache = NSCache<NSString, UIImage>()
    private let cacheDirectory: URL
    private let expiration: ExpirationPolicy = .forTimeInterval(time: 1800)
    
    private init() {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("ImageCache")
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating cache directory: \(error)")
            }
        }
    }
}

// MARK: - ImageCache extension for image retrieval and caching
extension ImageCache {
    
    /// Asynchronously sets an image for a given URL, with a completion handler.
    ///
    /// - Parameters:
    ///   - imageUrl: The URL of the image to be fetched and cached.
    ///   - completion: A closure to be called once the image is retrieved, providing the UIImage or nil.
    ///
    /// - Returns: A URLSessionDataTask representing the network request, or nil if the image is already in the memory cache.
    func setImage(imageUrl: String, completion: ((UIImage?) -> Void)? ) -> URLSessionDataTask? {
        if let cachedImage = getImage(forKey: imageUrl) {
            completion?(cachedImage)
            return nil
        } else {
            return request(url: imageUrl) { [weak self] data in
                guard let self = self else { return }
                if let data = data, let image = UIImage(data: data) {
                    self.setImage(image: image, forKey: imageUrl)
                    completion?(image)
                } else {
                    completion?(nil)
                }
            }
        }
    }
}

// MARK: - ImageCache extension for image retrieval
private extension ImageCache {
    
    /// Retrieves an image from the cache based on the expiration policy.
    ///
    /// - Parameter key: The unique key associated with the image.
    ///
    /// - Returns: The UIImage if found in cache and not expired, otherwise nil.
    private func getImage(forKey key: String) -> UIImage? {
        let fileUrl = cacheDirectory.appendingPathComponent(String(key.suffix(10)))
        if let data = try? Data(contentsOf: fileUrl), let image = UIImage(data: data) {
            
            switch expiration {
            case .never:
                if let cachedImage = memoryCache.object(forKey: key as NSString) {
                    return cachedImage
                }
                memoryCache.setObject(image, forKey: key as NSString)
                return image
            case .forTimeInterval(let time):
                let modificationDate = try? FileManager.default.attributesOfItem(atPath: fileUrl.path)[.modificationDate] as? Date
                if let modificationDate = modificationDate, Date().timeIntervalSince(modificationDate) > time {
                    try? FileManager.default.removeItem(at: fileUrl)
                    memoryCache.removeObject(forKey: key as NSString)
                    return nil
                } else {
                    if let cachedImage = memoryCache.object(forKey: key as NSString) {
                        return cachedImage
                    }
                    memoryCache.setObject(image, forKey: key as NSString)
                    return image
                }
            }
        }
        return nil
    }
}

// MARK: - ImageCache extension for image caching
private extension ImageCache {
    
    /// Caches an image in memory and on disk.
    ///
    /// - Parameters:
    ///   - image: The UIImage to be cached.
    ///   - key: The unique key associated with the image.
    func setImage(image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
        let fileUrl = cacheDirectory.appendingPathComponent(String(key.suffix(10)))
        if let data = image.pngData() {
            do {
                try data.write(to: fileUrl)
                try FileManager.default.setAttributes([.modificationDate: Date()], ofItemAtPath: fileUrl.path)
            } catch {
                print("Error writing image to cache: \(error)")
            }
        }
    }
}

// MARK: - ImageCache extension for network requests
private extension ImageCache {
    
    /// Initiates a network request to fetch image data for a given URL.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to be fetched.
    ///   - completion: A closure to be called once the data is retrieved, providing the Data or nil.
    ///
    /// - Returns: A URLSessionDataTask representing the network request.
    private func request(url: String, completion: @escaping (Data?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: url) else {
            completion(nil)
            return nil
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil)
                return
            }
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }
        task.resume()
        return task
    }
}
