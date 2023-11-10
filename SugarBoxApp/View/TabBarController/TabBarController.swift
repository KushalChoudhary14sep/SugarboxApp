//
//  TabbarController.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}

//MARK: - Setup Tab Bar
private extension TabBarController {
    
    /// Configures the Tab Bar with the required view controllers.
    private func setupTabBar() {
        let homeViewController = createTabItem(HomeViewController(), title: Local.TabBar.home.text, selectedImage: ImageAsset.TabBar.homeSelected.image, unselectedImage: ImageAsset.TabBar.homeUnselected.image)
        
        let moviesViewController = createTabItem(MoviesViewController(), title: Local.TabBar.movies.text, selectedImage: ImageAsset.TabBar.moviesSelected.image, unselectedImage: ImageAsset.TabBar.moviesUnselected.image)
        
        let showsViewController = createTabItem(ShowsViewController(), title: Local.TabBar.shows.text, selectedImage: ImageAsset.TabBar.showsSelected.image, unselectedImage: ImageAsset.TabBar.showsUnselected.image)
        
        let controllers = [homeViewController, moviesViewController, showsViewController]
        self.tabBar.backgroundColor = .tabbarBackground
        self.viewControllers = controllers
        self.selectedViewController = self.viewControllers?.first
        self.tabBar.barTintColor =  .tabbarBackground
    }
}

//MARK: - Create Tab Item
private extension TabBarController {
    
    /// Creates and configures a tab bar item for a given view controller.
    /// - Parameters:
    ///   - viewController: The view controller associated with the tab item.
    ///   - title: The title of the tab item.
    ///   - selectedImage: The selected state image of the tab item.
    ///   - unselectedImage: The unselected state image of the tab item.
    /// - Returns: The configured view controller with the associated tab item.
    private func createTabItem(_ viewController: UIViewController, title: String, selectedImage: UIImage?, unselectedImage: UIImage?) -> UIViewController {
        
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: unselectedImage?.withRenderingMode(.alwaysOriginal).withTintColor(.lightText),
            selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        )
        viewController.tabBarItem.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.lightText,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ],
            for: .normal
        )
        viewController.tabBarItem.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ],
            for: .selected
        )
        return viewController
    }
}

// Unused ViewController Tabs
class MoviesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .homeBackground
    }
}

class ShowsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .homeBackground
    }
}
