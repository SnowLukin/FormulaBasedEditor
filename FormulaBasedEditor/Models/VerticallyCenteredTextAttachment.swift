//
//  VerticallyCenteredTextAttachment.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 12.08.2023.
//

import UIKit

final class VerticallyCenteredTextAttachment: NSTextAttachment {
    var font: UIFont?

    override func attachmentBounds(
        for textContainer: NSTextContainer?,
        proposedLineFragment lineFrag: CGRect,
        glyphPosition position: CGPoint,
        characterIndex charIndex: Int
    ) -> CGRect {
        guard let font = self.font else {
            return super.attachmentBounds(
                for: textContainer,
                proposedLineFragment: lineFrag,
                glyphPosition: position,
                characterIndex: charIndex
            )
        }

        var bounds = super.attachmentBounds(
            for: textContainer,
            proposedLineFragment: lineFrag,
            glyphPosition: position,
            characterIndex: charIndex
        )

        let centerY = font.capHeight / 2.0
        bounds.origin.y = centerY - bounds.size.height / 2.0
        return bounds
    }
}
