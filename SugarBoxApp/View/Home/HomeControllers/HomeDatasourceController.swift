//
//  HomeDatasource.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 10/11/23.
//

import Foundation
import UIKit

// MARK: - HomeDataSourceController
/// Manages the data source for the UICollectionView in HomeViewController.
class HomeDataSourceController: NSObject {
    
    // MARK: Properties

    /// The instance of HomeViewModel responsible for providing data to the collection view.
    private let homeViewModel: HomeViewModel
    
    // MARK: Initializer
    
    /// Initializes the data source controller with the specified HomeViewModel.
    /// - Parameter homeViewModel: The HomeViewModel instance.
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
}

// MARK: - UICollectionView Datasource Extension
extension HomeDataSourceController: UICollectionViewDataSource {
    
    /// Returns the number of sections in the collection view.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.homeViewModel.homeModel.sections.count
    }
    
    /// Returns the number of items in the specified section of the collection view.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    /// Asks the data source for a cell to insert in a particular location of the collection view.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.homeViewModel.homeModel.sections[indexPath.section] {
        case .ottRail:
            let cell = HomeRailCell.dequeue(collectionView: collectionView, indexpath: indexPath)
            let railData = homeViewModel.fetchRailData(row: indexPath.section)
            cell.setData(data: railData)
            return cell
        case .carousel:
            let cell = CarouselCell.dequeue(collectionView: collectionView, indexpath: indexPath)
            let carouselAsset: [String] = homeViewModel.fetchCarouselAsset(row: indexPath.section)
            cell.setData(list: carouselAsset)
            return cell
        }
    }
}
