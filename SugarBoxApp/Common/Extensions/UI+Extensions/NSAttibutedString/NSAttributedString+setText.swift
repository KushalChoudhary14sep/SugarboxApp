//
//  NSAttributedString+setText.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func setAttributedText(text: String, font: UIFont, color: UIColor, additionalAttributes: [NSAttributedString.Key: Any] = [:], range: NSRange? = nil) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: color
            ]
        attributes.merge(additionalAttributes) { (_, new) in new }
        let string = NSMutableAttributedString(string: text, attributes: attributes)
        if let range = range {
               let additionalAttributedString = NSAttributedString(string: text, attributes: additionalAttributes)
            string.addAttributes(additionalAttributedString.attributes(at: 0, effectiveRange: nil), range: range)
        }
        return string
    }
}
