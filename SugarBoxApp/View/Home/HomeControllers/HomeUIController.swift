//
//  HomeUIController.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 10/11/23.
//

import Foundation
import UIKit

// MARK: - Home UI Controller
/// Manages the UI configuration for the HomeViewController and handles data updates.
class HomeUIController {
    
    // MARK: Properties
    
    /// The weak reference to the HomeView associated with this controller.
    weak var view: HomeView? {
        didSet {
            guard let view = view else { return }
            configure(view: view)
        }
    }
    
    /// Configuring the UI Controller
    private func configure(view: HomeView) {
        setupUI(view: view)
        setupCollectionView(view: view)
    }
    
    // MARK: Private Properties

    /// The instance of HomeViewModel responsible for managing data for the HomeView.
    private lazy var homeViewModel: HomeViewModel = {
        let homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
        homeViewModel.reset()
        return homeViewModel
    }()
    
    /// The data source controller for the HomeView's collection view.
    private lazy var datasource: HomeDataSourceController = {
        let datasource = HomeDataSourceController(homeViewModel: homeViewModel)
        return datasource
    }()
}

// MARK: - HomeViewModelDelegates Extension
extension HomeUIController: HomeViewModelDelegates {
    
    /// Handles changes in the HomeViewModel's status.
    /// - Parameter status: The HomeStatus indicating the current state.
    func didStatusChange(status: HomeStatus) {
        guard let view = view else { return }
        switch status {
        case .didReset:
            setResetUIState(view: view)
            
        case .willFetchNewDatafor(let page):
            setWillFetchHomeFeedsUIState(for: page, view: view)
            
        case .didHomeFeedsFetched:
            setFetchedHomeFeedsUIState(view: view)
            
        case .noFeedsFound:
            setNoFeedsUIState(view: view)
            
        case .didFailToFetch(let error):
            switch error {
            case .unknown:
                setUnknownErrorUIState(view: view)
            case .noInternet:
                setNoInternetUIState(view: view)
            }
        }
    }
}

// MARK: - CollectionView Setup Extension
private extension HomeUIController {
    
    /// Configures the collection view for the HomeViewController.
    /// - Parameter view: The HomeView where the collection view is displayed.
    private func setupCollectionView(view: HomeView) {
        view.collectionView.collectionViewLayout = createLayout()
        view.collectionView.backgroundColor = .clear
        view.collectionView.allowPullToRefresh = true
        view.collectionView.refreshControl?.addTarget(self, action: #selector(didPulledToRefresh), for: .valueChanged)
        view.collectionView.paginator = homeViewModel.paginator
        view.collectionView.dataSource = datasource
        CarouselCell.registerTo(collectionView: view.collectionView)
        HomeRailCell.registerTo(collectionView: view.collectionView)
    }
    
    @objc private func didPulledToRefresh() {
        homeViewModel.reset()
        view?.collectionView.reloadData()
    }
}

// MARK: - CollectionView Layout Extension
private extension HomeUIController {
    
    /// Creates the layout for the collection view.
    /// - Returns: A UICollectionViewLayout object.
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [unowned self] sectionIndex, layoutEnvironment in
            let section = self.homeViewModel.homeModel.sections[sectionIndex]
            switch section {
            case .ottRail:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 16, trailing: 0)
                return section
            case .carousel:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(210)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(210)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 16, trailing: 0)
                return section
            }
        }
    }
}

//MARK: - Set UI State
/// Handles UI state changes based on the provided HomeStatus.
private extension HomeUIController {
    
    private func setResetUIState(view: HomeView) {
        DispatchQueue.main.async {
            view.collectionView.hideBottomLoader()
        }
    }
    
    private func setWillFetchHomeFeedsUIState(for page: Int, view: HomeView) {
        DispatchQueue.main.async {
            page == 0 ? view.collectionView.showLoader(tag: 100) : view.collectionView.showBottomLoader()
        }
    }
    
    private func setFetchedHomeFeedsUIState(view: HomeView) {
        DispatchQueue.main.async {
            view.collectionView.removeErrorPlaceHolder()
            view.collectionView.refreshControl?.endRefreshing()
            view.collectionView.hideBottomLoader()
            view.collectionView.hideLoader(tag: 100)
            view.collectionView.reloadData()
        }
    }
    
    private func setNoFeedsUIState(view: HomeView) {
        DispatchQueue.main.async {
            view.collectionView.hideLoader(tag: 100)
            view.collectionView.showErrorPlaceholder(titleText: "No Feeds!", subTitleText: "We are working on it to get you the best content.") { [weak self] in
                self?.homeViewModel.reset()
            }
        }
    }
    
    private func setNoInternetUIState(view: HomeView) {
        DispatchQueue.main.async {
            view.collectionView.hideLoader(tag: 100)
            view.collectionView.showErrorPlaceholder(titleText: "No Internet!", subTitleText: "Please reset your internet connection.") { [weak self] in
                self?.homeViewModel.reset()
            }
        }
    }
    
    private func setUnknownErrorUIState(view: HomeView) {
        DispatchQueue.main.async {
            view.collectionView.hideLoader(tag: 100)
            view.collectionView.showErrorPlaceholder { [weak self] in
                self?.homeViewModel.reset()
            }
        }
    }
}

// MARK: - Setup UI Extension
private extension HomeUIController {
    private func setupUI(view: HomeView) {
        view.view.backgroundColor = .homeBackground
    }
}
