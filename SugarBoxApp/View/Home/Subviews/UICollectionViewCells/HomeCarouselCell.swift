//
//  HomeCarouselCell.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

// MARK: - CarouselCell
/// A custom `UICollectionViewCell` that displays a carousel of images with a page control.
class CarouselCell: UICollectionViewCell {
    
    // MARK: Properties

    private var dataList: [String] = []
    
    private lazy var pager: UIPageControl = {
        let view = UIPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesForSinglePage = true
        view.currentPageIndicatorTintColor = .homePrimary
        view.pageIndicatorTintColor = .white
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .clear
        ImageCell.registerTo(collectionView: collectionView)
        collectionView.dataSource = self
        return collectionView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Data Configuration Extension
extension CarouselCell {
    
    /// Sets the data for the carousel cell.
    /// - Parameter list: The list of image data to be displayed.
    func setData(list: [String]) {
        self.dataList = list
        pager.numberOfPages = list.count
        collectionView.reloadData()
    }
}

// MARK: - Setup Views Extension
extension CarouselCell {
    
    /// Sets up the views within the carousel cell.
    private func setupViews() {
        self.backgroundColor = .clear
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        
        self.addSubview(pager)
        NSLayoutConstraint.activate([
            pager.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
            pager.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pager.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -4)
        ])
    }
}

// MARK: - UICollectionView Datasource Extension
extension CarouselCell: UICollectionViewDataSource {
    
    /// Returns the number of items in the carousel.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    /// Returns a configured cell for a specific item in the carousel.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ImageCell.dequeue(collectionView: collectionView, indexpath: indexPath)
        if let data = self.dataList[circular: indexPath.row] {
            cell.setImage(imagePath: data)
        }
        return cell
    }
}

// MARK: - UICollectionView Layout Extension
private extension CarouselCell {
    
    /// Creates the layout for the carousel collection view.
    private func collectionViewLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { [weak self] _, offset, _ in
            guard let self = self else { return }
            let pageWidth = self.collectionView.frame.size.width * 0.9 + 16
            let currentPage = Int((offset.x + pageWidth / 2) / pageWidth)
            self.pager.currentPage = currentPage
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
