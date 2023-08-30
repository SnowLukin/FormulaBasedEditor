//
//  CurrentDocumentTextView.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 01.07.2023.
//

import UIKit

class CurrentDocumentTextView: UITextView {

    let cursorHeight: CGFloat = 20.0

    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let font = self.font else { return superRect }

        // "descender" is expressed as a negative value,
        // so to add its height you must subtract its value
        let height = superRect.size.height
        let newHeight = font.pointSize - font.descender
        superRect.size.height = newHeight
        superRect.origin.y = (height - newHeight / 2) / 2
        return superRect
    }
}

/// 1/1/1/1/1/1/1-1+3/2*4
