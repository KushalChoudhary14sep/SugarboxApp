//
//  DynamicHeighCollectionView.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

// MARK: - AppCollectionView
/// A subclass of UICollectionView with additional features:
/// - Set `allowPullToRefresh` to enable or disable Pull to Refresh.
/// - Set `paginator` for pagination support.
/// - Manages the visibility of the bottom loader during pagination.
class AppCollectionView: UICollectionView {
    
    // MARK: Initialization

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .init(origin: .zero, size: .init(width: 300, height: 50)), collectionViewLayout: layout)
        UICollectionViewCell.registerTo(collectionView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    private lazy var bottomLoader: UIActivityIndicatorView = {
        return .init(style: .medium)
    }()
    
    private var totalNumberOfItems: Int {
        var total = 0
        for section in 0..<numberOfSections {
            total += self.dataSource?.collectionView(self, numberOfItemsInSection: section) ?? 0
        }
        return total
    }
        
    var allowPullToRefresh: Bool = false {
        didSet {
            addRefreshControl()
        }
    }
    
    weak var pagingDelegate: PaginatorDelegate? {
        didSet {
            if let newValue = pagingDelegate {
                paginator = .init(delegate: newValue)
                paginator?.viewingItemAt(indexPath: .init(row: -1, section: 0), currentItemCount: 0)
            } else {
                paginator = nil
            }
        }
    }
    
    var paginator: Paginator? {
        didSet {
            let currentItemCount:Int
            currentItemCount = self.dataSource?.collectionView(self, numberOfItemsInSection: (self.dataSource?.numberOfSections?(in: self) ?? 0) - 1) ?? 0
            guard let index = self.indexPathsForVisibleItems.last else {
                paginator?.viewingItemAt(indexPath: .init(row: -1, section: 0), currentItemCount: currentItemCount)
                return }
            paginator?.viewingItemAt(indexPath: index, currentItemCount: currentItemCount)
        }
    }
}

//MARK: - AppCollectionView - Reload Data / Dequeue Reusable Cell
extension AppCollectionView {
    override func reloadData() {
        super.reloadData()
        layoutIfNeeded()
    }
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let currentItemCount:Int
        currentItemCount = self.dataSource?.numberOfSections?(in: self) ?? 0
        paginator?.viewingItemAt(indexPath: indexPath, currentItemCount: currentItemCount)
        return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}

//MARK: - Show / Hide Bottom Loader for Pagination
extension AppCollectionView {
    func showBottomLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            if totalNumberOfItems < 1 { return }
            let midX: CGFloat = self.frame.width / 2
            let midY: CGFloat = max((self.contentSize.height + self.contentInset.bottom), 50)
            let height: CGFloat = 50
            let width: CGFloat = 50
            self.bottomLoader.frame = .init(x:  midX - (width/2), y: midY - 50 , width: 50, height: height)
            self.addSubview(self.bottomLoader)
            self.bottomLoader.startAnimating()
        }
    }
    
    func hideBottomLoader() {
        self.bottomLoader.stopAnimating()
        self.bottomLoader.removeFromSuperview()
    }
}

//MARK: - Add Refresh Control
private extension AppCollectionView {
    private func addRefreshControl() {
        if self.allowPullToRefresh && self.refreshControl == nil {
            let control = UIRefreshControl()
            control.tintColor = .white
            self.refreshControl = control
        } else if self.allowPullToRefresh == false && self.refreshControl != nil {
            self.refreshControl = nil
        }
    }
}
