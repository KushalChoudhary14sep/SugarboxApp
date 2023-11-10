//
//  HomeRail.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

// MARK: - HomeRailCell
/// A custom `UICollectionViewCell` that displays a rail of thumbnail images with a header.
class HomeRailCell: UICollectionViewCell {
    
    // MARK: Properties

    /// The data model representing the rail with header.
    private var data: HomeModel.HomeThumbnailRailWithHeader?
    
    /// The leading icon view of the rail header.
    private lazy var headerLeadingIconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .homePrimary
        return view
    }()
    
    /// The label displaying the title of the rail header.
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    /// The collection view responsible for displaying the rail's thumbnail images.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func layoutSubviews() {
        headerLeadingIconView.layer.cornerRadius = headerLeadingIconView.frame.width / 2
    }
    
    /// Called before the cell is reused, preparing it for a new set of data.
    override func prepareForReuse() {
        super.prepareForReuse()
        self.data = nil
        self.collectionView.reloadData()
    }
}

// MARK: - Set Data Extension
extension HomeRailCell {
    
    /// Sets the data for the HomeRailCell.
    /// - Parameter data: The data model representing the rail with header.
    func setData(data: HomeModel.HomeThumbnailRailWithHeader) {
        self.data = data
        self.headerLabel.text = data.title
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource Extension
extension HomeRailCell: UICollectionViewDataSource {
    
    /// Returns the number of sections in the collection view (always 1 for this cell).
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    /// Returns the number of thumbnail items in the rail.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.railAsset.count ?? 0
    }
    
    /// Returns a configured cell for a specific thumbnail item in the rail.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ImageCell.dequeue(collectionView: collectionView, indexpath: indexPath)
        guard let asset = data?.railAsset[circular: indexPath.row] else { return cell }
        cell.setImage(imagePath: asset)
        return cell
    }
}

// MARK: - Setup Views Extension
private extension HomeRailCell {
    
    /// Sets up the views within the HomeRailCell.
    private func setupViews() {
        self.backgroundColor = .clear
    
        addSubview(headerLeadingIconView)
        NSLayoutConstraint.activate([
            headerLeadingIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLeadingIconView.topAnchor.constraint(equalTo: topAnchor),
            headerLeadingIconView.heightAnchor.constraint(equalToConstant: 20),
            headerLeadingIconView.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: headerLeadingIconView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerLeadingIconView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - UICollectionView Layout Extension
private extension HomeRailCell {
    
    /// Creates the layout for the rail's collection view.
    private func collectionViewLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 12
        return UICollectionViewCompositionalLayout(section: section)
    }
}
