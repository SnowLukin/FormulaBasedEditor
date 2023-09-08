//
//  NSAttributedString+Font.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 04.09.2023.
//

import UIKit

extension NSAttributedString {
    func firstFont() -> UIFont? {
        var fonts = [UIFont]()
        self.enumerateAttribute(.font, in: NSRange(0..<self.length), options: []) { (value, range, stop) in
            if let font = value as? UIFont {
                fonts.append(font)
            }
        }
        return fonts.first
    }
}
