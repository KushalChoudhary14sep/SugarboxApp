//
//  AppNavigationDelegate.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 08/11/23.
//

import Foundation
import UIKit

// MARK: - App Navigation Delegate
/// A singleton class responsible for managing the application's navigation stack and `UINavigationController`.
/// Use this class to control the app's navigation flow and maintain the navigation stack.
final class AppNavigationDelegate: NSObject  {
    
    private override init() {
        super.init()
    }
    var navigationController = UINavigationController()
    var window: UIWindow?
    
    static var shared = AppNavigationDelegate()

    
}

// MARK: - AppNavigationDelegate - UIApplicationDelegate
/// Configures the initial setup of the application's navigation stack and root view controller.
extension AppNavigationDelegate: UIApplicationDelegate {
    
    @discardableResult func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigation = navigationController
        navigation.setViewControllers([TabBarController()], animated: true)
        navigation.isNavigationBarHidden = true
        window = UIWindow()
        window?.backgroundColor = .white
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }
}
