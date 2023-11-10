//
//  Modal.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation

// MARK: - HomeSection
/// Enum representing possible sections to be displayed on the Home page.
enum HomeSection {
    
    /// Section for displaying OTT rail.
    case ottRail
    
    /// Section for displaying a carousel.
    case carousel
}

// MARK: - HomeModel
/// Modal struct to manage data for the Home Page.
struct HomeModel {
    
    // MARK: Properties
    
    /// An array containing HomeFeed objects for the Home Page.
    var homeFeeds:[HomeFeed] = [] {
        didSet{
            sections = []
            self.configureSections(homeFeed: homeFeeds)
        }
    }
    
    /// An array representing the sections to be displayed on the Home Page.
    private(set) var sections: [HomeSection] = []
    
    // MARK: Nested Struct
    
    /// Struct representing data for Home Thumbnail Rail with Header.
    struct HomeThumbnailRailWithHeader {
        let title: String
        let railAsset: [String]
    }
}

// MARK: - Fetch Home Rail
extension HomeModel {
    
    /// Fetches data for the Home Thumbnail Rail with Header.
    ///
    /// - Parameter row: The row for which to fetch the data.
    /// - Returns: An instance of `HomeThumbnailRailWithHeader`.
    mutating func fetchHomeRail(for row: Int) -> HomeModel.HomeThumbnailRailWithHeader {
        let railAsset: [String] = fetchAsset(for: row, of: .thumbnailList)
        return .init(title: homeFeeds[circular: row]?.title ?? "", railAsset: railAsset)
    }
}

//MARK: - Fetch Asset
extension HomeModel {
    
    /// Fetches assets for a given row and type.
    ///
    /// - Parameters:
    ///   - row: The row for which to fetch the assets.
    ///   - type: The type of asset to fetch.
    /// - Returns: An array of asset paths.
    mutating func fetchAsset(for row: Int, of type: TypeEnum) -> [String] {
        var assets: [String] = []
        homeFeeds[circular: row]?.contents.forEach({ content in
            content.assets.forEach { asset in
                switch asset.assetType {
                case .image:
                    if asset.type == type {
                        assets.append(asset.sourcePath)
                    }
                case .video:
                    break
                }
            }
        })
        return assets
    }
}

//MARK: - Configure Sections
extension HomeModel {
    
    /// Configures sections based on the input HomeFeed data.
    ///
    /// - Parameter homeFeed: The array of HomeFeed objects.
    mutating private func configureSections(homeFeed: [HomeFeed]) {
        homeFeed.forEach { feed in
            switch feed.designSlug {
            case .ottRail:
                sections.append(.ottRail)
            case .carousel:
                sections.append(.carousel)
            }
        }
    }
}
