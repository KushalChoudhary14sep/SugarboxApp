//
//  UICollectionView.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    @objc class func dequeue(collectionView: UICollectionView, indexpath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexpath) as! Self
    }
    class var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    class var nib: UINib? {
        return UINib(nibName: reuseIdentifier, bundle: .main)
    }
    @objc class func registerTo(collectionView: UICollectionView) {
        collectionView.register(Self.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
