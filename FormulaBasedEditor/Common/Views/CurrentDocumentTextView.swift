//
//  CurrentDocumentTextView.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 01.07.2023.
//

import UIKit

final class CurrentDocumentTextView: UITextView {
    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let font = self.font else { return superRect }
        
        let lineHeight = font.lineHeight
        let yOffset = (superRect.size.height - lineHeight) / 2
        
        superRect.size.height = lineHeight
        superRect.origin.y += yOffset
        
        return superRect
    }
}
