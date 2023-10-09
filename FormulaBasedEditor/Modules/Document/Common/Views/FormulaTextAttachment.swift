//
//  VerticallyCenteredTextAttachment.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 12.08.2023.
//

import UIKit

final class FormulaTextAttachment: NSTextAttachment {
    var font: UIFont?
    var alignment: Alignment = .middle
    
    override class var supportsSecureCoding: Bool {
        true
    }
    
    override init(data contentData: Data?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
        
        guard let data = contentData else { return }
        if self.image == nil {
            print("self.image is nil")
            self.image = UIImage(data: data)
            return
        }
        print("self.image is NOT nil")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func attachmentBounds(
        for textContainer: NSTextContainer?,
        proposedLineFragment lineFrag: CGRect,
        glyphPosition position: CGPoint,
        characterIndex charIndex: Int
    ) -> CGRect {
        let font = self.font ?? .systemFont(ofSize: 20)

        var bounds = super.attachmentBounds(
            for: textContainer,
            proposedLineFragment: lineFrag,
            glyphPosition: position,
            characterIndex: charIndex
        )
        if alignment == .middle {
            let centerY = font.capHeight / 2.0
            bounds.origin.y = centerY - bounds.size.height / 2.0
        }
        return bounds
    }
}

extension FormulaTextAttachment {
    enum Alignment {
        case normal
        case middle
    }
    
    struct Params {
        let uuid: String
        let formulaString: String
        let alignment: Alignment
    }
}
