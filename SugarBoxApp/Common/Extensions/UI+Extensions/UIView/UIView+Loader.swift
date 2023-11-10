//
//  UIView+Loader.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 10/11/23.
//

import Foundation
import UIKit

//MARK: - Show Loader
extension UIView {
    func showLoader(withTitle: String? = nil, tag: Int) {
        if let collectionview = self as? UIScrollView {
            collectionview.setContentOffset(.zero, animated: true)
            collectionview.isScrollEnabled = false
        }
        
        let oldloader =  self.parentViewController?.view.subviews.filter({ $0.tag == tag } ).first
        guard oldloader == nil else { return }
        
        let loader = Loader(title: withTitle)
        loader.tag = tag
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.layer.cornerRadius = self.layer.cornerRadius
        loader.layer.maskedCorners = self.layer.maskedCorners
        
        guard let parentViewController = self.parentViewController else {
            return }
        
        parentViewController.view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loader.heightAnchor.constraint(equalTo: self.heightAnchor),
            loader.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        
        if let header = self.subviews.first(where: { $0 is HomeHeaderView }) {
            self.bringSubviewToFront(header)
        }
    }
}

//MARK: - Hide Loader
extension UIView {
    func hideLoader(tag: Int) {
        if let collectionview = self as? UIScrollView {
            collectionview.isScrollEnabled = true
        }
        _ = self.parentViewController?.view.subviews.filter({ $0.tag == tag } ).map({ $0.removeFromSuperview() })
    }
}

extension UIView {
    private static var _myComputedProperty = [String:String]()
    var identifier:String {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView._myComputedProperty[tmpAddress] ?? ""
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView._myComputedProperty[tmpAddress] = newValue
        }
    }
    
    var parentViewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
