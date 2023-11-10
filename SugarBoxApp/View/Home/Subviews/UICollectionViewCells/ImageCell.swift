//
//  ImageCell.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

// MARK: - ImageCell
/// A custom `UICollectionViewCell` that displays an image.
class ImageCell: UICollectionViewCell {
    
    // MARK: Properties

    /// The task for loading the image from the network.
    private var task: URLSessionDataTask?
    
    /// The image view displaying the content of the cell.
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called when the bounds of the cell change.
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
    
    /// Called before the cell is reused, canceling any ongoing tasks and resetting the image.
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        imageView.image = nil
    }
}

// MARK: - Set Image Extension
extension ImageCell {
    
    /// Sets the image for the ImageCell by loading the image from ImageCache using the specified imagePath.
    /// - Parameter imagePath: The path of the image to be loaded from the network.
    func setImage(imagePath: String) {
        let imageURL = "https://static01.sboxdc.com/images" + imagePath
        task = ImageCache.shared.setImage(imageUrl: imageURL) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}

// MARK: - Setup Views Extension
private extension ImageCell {
    
    /// Sets up the views within the ImageCell.
    private func setupViews() {
        self.backgroundColor = .clear
        
        addSubview(imageView)
        imageView.backgroundColor = .white
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
