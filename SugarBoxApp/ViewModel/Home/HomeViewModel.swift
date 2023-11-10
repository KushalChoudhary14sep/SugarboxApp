//
//  HomeViewModel.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation

// MARK: - HomeStatus
/// Enum representing different states of data binding.
enum HomeStatus {
    
    /// Indicates that the data has been reset.
    case didReset
    
    /// Indicates that new data is about to be fetched for a specific page.
    case willFetchNewDatafor(page: Int)
    
    /// Indicates that home feeds have been successfully fetched.
    case didHomeFeedsFetched
    
    /// Indicates that no feeds were found.
    case noFeedsFound
    
    /// Indicates that there was a failure to fetch home feeds, with an associated error.
    case didFailToFetch(error: HomeFeedRepositoryError)
}

// MARK: - Status Change Delegate
/// Delegate protocol to receive updates when the HomeStatus changes.
protocol HomeViewModelDelegates: AnyObject {
    
    /// Called when the HomeStatus changes.
    ///
    /// - Parameter status: The new HomeStatus.
    func didStatusChange(status: HomeStatus)
}

// MARK: - HomeViewModel
/// View model class for managing the Home Page data.
final class HomeViewModel {
    
    // MARK: Properties
    
    /// Paginator for handling paginated data fetching.
    lazy var paginator: Paginator = { .init(delegate: self) }()
    
    /// Delegate to receive status change updates.
    weak var delegate: HomeViewModelDelegates?
    
    /// Repository for fetching home feeds.
    private let repository = HomeFeedRepository()
    
    /// Model containing data for the Home Page.
    var homeModel = HomeModel()
    
    /// Status variable to track changes in data binding.
    private var homeStatus: HomeStatus? {
        didSet {
            guard let homeStatus = homeStatus, let delegate = delegate else { return }
            delegate.didStatusChange(status: homeStatus)
        }
    }
}

// MARK: - HomeViewModel - Helper Fetch methods
extension HomeViewModel {
    
    /// Fetches carousel assets for a specific row.
    ///
    /// - Parameter row: The row for which to fetch carousel assets.
    /// - Returns: An array of carousel asset paths.
    func fetchCarouselAsset(row: Int) -> [String] {
        homeModel.fetchAsset(for: row, of: .thumbnail)
    }
    
    /// Fetches rail data for a specific row.
    ///
    /// - Parameter row: The row for which to fetch rail data.
    /// - Returns: An instance of `HomeThumbnailRailWithHeader`.
    func fetchRailData(row: Int) -> HomeModel.HomeThumbnailRailWithHeader {
        homeModel.fetchHomeRail(for: row)
    }
}

//MARK: - HomeViewModel - Reset
extension HomeViewModel {
    
    /// Clears the existing data and resets the paginator to fetch new data.
    func reset() {
        homeModel.homeFeeds.removeAll()
        paginator.reset()
    }
}

//MARK: - Paginator Delegate Implementation
extension HomeViewModel: PaginatorDelegate {
    
    /// Performs a network request for a specific page.
    ///
    /// - Parameters:
    ///   - page: The page number for which to fetch data.
    ///   - paginator: The paginator initiating the request.
    func paginate(to page: Int, for paginator: Paginator) {
        if page == 0 {
            homeModel.homeFeeds.removeAll()
        }
        
        self.homeStatus = .willFetchNewDatafor(page: page)
        
        repository.fetchHomeFeeds(page: page, limit: 10) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.homeModel.homeFeeds.append(contentsOf: response.data)
                self.homeStatus = self.homeModel.homeFeeds.isEmpty ? .noFeedsFound : .didHomeFeedsFetched
                
            case .failure(let error):
                self.homeStatus = .didFailToFetch(error: error)
            }
        }
    }
}
