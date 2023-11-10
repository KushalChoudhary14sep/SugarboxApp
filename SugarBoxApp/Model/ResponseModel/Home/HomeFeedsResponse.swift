//
//  HomeFeedsResponse.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation

// MARK: - HomeFeedsResponse
struct HomeFeedsResponse: Codable {
    let data: [HomeFeed]
    let pagination: Pagination
}

enum DesignSlug: String, Codable {
    case ottRail = "OTTWidget"
    case carousel = "CarousalWidget"
}

// MARK: - Datum
struct HomeFeed: Codable {
    let title: String
    let contents: [Content]
    let designSlug: DesignSlug

    enum CodingKeys: String, CodingKey {
        case title, designSlug, contents
    }
}

// MARK: - Content
struct Content: Codable {
    let assets: [HomeAsset]

    enum CodingKeys: String, CodingKey {
        case assets
    }
}

// MARK: - Asset
struct HomeAsset: Codable {
    let assetType: AssetType
    let sourceURL: String
    let type: TypeEnum
    let sourcePath: String

    enum CodingKeys: String, CodingKey {
        case assetType
        case sourceURL = "sourceUrl"
        case type, sourcePath
    }
}

enum AssetType: String, Codable {
    case image = "IMAGE"
    case video = "VIDEO"
}

enum TypeEnum: String, Codable {
    case dash = "dash"
    case detail = "detail"
    case hls = "hls"
    case thumbnail = "thumbnail"
    case thumbnailList = "thumbnail_list"
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalPages, currentPage, perPage, totalCount: Int
}
