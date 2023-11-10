//
//  HomeViewController.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

// MARK: - HomeView Protocol
/// A protocol defining the required properties for the HomeViewController.
protocol HomeView: UIViewController {
    var headerView: HomeHeaderView { get }
    var collectionView: AppCollectionView { get }
}

// MARK: - HomeViewController Class
class HomeViewController: UIViewController, HomeView {
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConstraints()
        uiController.view = self
    }
    
    // MARK: Properties

    private lazy var uiController: HomeUIController = {
        let uiController = HomeUIController()
        return uiController
    }()
    
    lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(with: "Sugarbox")
        return view
    }()
    
    lazy var collectionView: AppCollectionView = {
        let collectionView = AppCollectionView(frame: .init(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
}

// MARK: - Setup View Constraints Extension
private extension HomeViewController {
    
    /// Sets up the layout constraints for the HomeViewController's subviews.
    private func setupViewConstraints() {
        // HeaderView Constraints
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // CollectionView Constraints
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
