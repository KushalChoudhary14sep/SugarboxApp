//
//  ImageAsset.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

//MARK: - ImageAsset
/// - Use respective enum and it's case to get image
class ImageAsset {
    enum TabBar {
        case homeSelected
        case homeUnselected
        case moviesSelected
        case moviesUnselected
        case showsSelected
        case showsUnselected
        
        var image: UIImage? {
            switch self {
            case .homeSelected:
                return UIImage(systemName: "house")
            case .homeUnselected:
                return UIImage(systemName: "house")
            case .moviesSelected:
                return UIImage(systemName: "film")
            case .moviesUnselected:
                return UIImage(systemName: "film")
            case .showsSelected:
                return UIImage(systemName: "tv")
            case .showsUnselected:
                return UIImage(systemName: "tv")
            }
        }
    }
}
