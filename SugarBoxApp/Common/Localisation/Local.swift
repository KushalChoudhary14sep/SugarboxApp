//
//  Local.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation

//MARK: - Local
/// - Use respective enum and it's case to get localised text.
class Local {
    enum TabBar: String {
        var text: String {
            return self.rawValue.localized
        }
        case home = "tabbar/home"
        case movies = "tabbar/movies"
        case shows = "tabbar/shows"
    }
}
