//
//  NSAttributedStringTransformer.swift
//  FormulaBasedEditor
//
//  Created by Denis Mandych on 27.08.2023.
//

import Foundation

@objc(NSAttributedStringTransformer)
class NSAttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [NSAttributedString.self]
    }
}
