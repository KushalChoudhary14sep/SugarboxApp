//
//  Array.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation

extension Array {
    subscript(circular index: Int) -> Element? {
        var i = index
        if i < 0 || isEmpty {
            return nil
        } else if i > count - 1 {
            i = index % count
        }
        return self[i]
    }
}
