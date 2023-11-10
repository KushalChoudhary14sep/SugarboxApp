//
//  Loader.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

// MARK: - Loader
/// A custom UIView that displays a loading indicator with an optional title.
final class Loader: UIView {
    
    // MARK: Initialization
    
    /// Initializes the Loader view with an optional title.
    /// - Parameter title: The title to be displayed below the loading indicator.
    init(title: String?) {
        super.init(frame: .zero)
        backgroundColor = .homeBackground
        setupLoader(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Loader
private extension Loader {
    
    /// Configures the loading indicator and title label, if provided.
    /// - Parameter title: The title to be displayed below the loading indicator.
    private func setupLoader(title: String?) {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tintColor = .white
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        activityIndicator.startAnimating()
        
        if let loaderTitle = title {
            let textlabel : UILabel = {
                let title = UILabel()
                title.translatesAutoresizingMaskIntoConstraints = false
                title.attributedText = NSAttributedString.setAttributedText(
                    text: loaderTitle,
                    font: .systemFont(ofSize: 14, weight: .medium),
                    color: .white
                )
                title.textAlignment = .center
                title.numberOfLines = 0
                return title
            }()
            
            addSubview(textlabel)
            NSLayoutConstraint.activate([
                textlabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
                textlabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                textlabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                textlabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -32)
            ])
        }
    }
}
