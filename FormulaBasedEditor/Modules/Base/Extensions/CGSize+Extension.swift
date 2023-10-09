//
//  CGSize+Extension.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 12.08.2023.
//

import Foundation

extension CGSize {
    mutating func add(_ size: CGSize) {
        width += size.width
        height += size.height
    }

    mutating func addWithHeightLimit(_ size: CGSize) {
        width += size.width
        height = max(height, size.height)
    }

    mutating func addWithWidthLimit(_ size: CGSize) {
        width += max(height, size.height)
        height += size.height
    }
}
