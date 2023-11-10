//
//  String.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation

extension String {
    var localized: String {
       return NSLocalizedString(self, comment: self)
    }
}
