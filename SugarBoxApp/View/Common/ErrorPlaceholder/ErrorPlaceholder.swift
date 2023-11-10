//
//  UnknownErrorPlaceholder.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - Error Handling
    
    /// Displays an error placeholder view on the current UIView.
    ///
    /// - Parameters:
    ///   - titleText: The title text to be displayed on the error placeholder.
    ///   - subTitleText: The subtitle text to be displayed on the error placeholder.
    ///   - cta: A closure to be executed when the "Try Again" button is tapped.
    func showErrorPlaceholder(titleText: String = "Uh-oh! An Error Occurred", subTitleText: String = "We apologize, but it appears that something didn't go as expected.", cta: ( () -> Void )? ) {
        if let collectionview = self as? UIScrollView {
            DispatchQueue.main.async {
                collectionview.isScrollEnabled = false
                collectionview.setContentOffset(.zero, animated: true)
            }
        }
        let view: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .homeBackground
            
            let errorImage: UIImageView = {
                let imageview = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
                imageview.translatesAutoresizingMaskIntoConstraints = false
                return imageview
            }()
            
            let title: UILabel = {
                let title = UILabel()
                title.translatesAutoresizingMaskIntoConstraints = false
                title.attributedText = NSAttributedString.setAttributedText(text: titleText, font: .systemFont(ofSize: 14, weight: .medium), color: .white)
                title.numberOfLines = 0
                title.textAlignment = .center
                return title
            }()
            
            
            let subtitle : UILabel = {
                let title = UILabel()
                title.translatesAutoresizingMaskIntoConstraints = false
                title.attributedText = NSAttributedString.setAttributedText(text: subTitleText, font: .systemFont(ofSize: 13, weight: .regular), color: .white)
                title.numberOfLines = 0
                title.textAlignment = .center
                return title
            }()
            
            let button = UIButton()
            button.setTitle("Try Again", for: .normal)
            button.addAction(.init(handler: { [weak self] _ in
                cta?()
                self?.removeErrorPlaceHolder()
            }), for: .touchUpInside)
            
            let stack = UIStackView(arrangedSubviews: [errorImage, title, subtitle, button])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.alignment = .center
            stack.axis = .vertical
            stack.setCustomSpacing(24, after: errorImage)
            stack.setCustomSpacing(4, after: title)
            stack.setCustomSpacing(24, after: subtitle)
            view.addSubview(stack)
            
            NSLayoutConstraint.activate([
                stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
                stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
            ])
            
            view.tag = 333
            return view
        }()
        
        self.addSubview(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalTo: self.heightAnchor),
            view.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        if let header = self.subviews.first(where: { $0 is HomeHeaderView }) {
            self.bringSubviewToFront(header)
        }
    }
    
    /// Removes the error placeholder view from the current UIView.
    func removeErrorPlaceHolder() {
        DispatchQueue.main.async {
            if let scrollview = self as? UIScrollView {
                scrollview.isScrollEnabled = true
            }
            self.subviews.forEach({
                if $0.tag == 333 {
                    $0.removeFromSuperview()
                }
            })
        }
    }
}
