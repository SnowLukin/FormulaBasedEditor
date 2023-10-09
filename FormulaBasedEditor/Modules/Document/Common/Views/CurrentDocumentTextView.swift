//
//  CurrentDocumentTextView.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 01.07.2023.
//

import UIKit

final class CurrentDocumentTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero, textContainer: nil)
        setupView()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let font = self.font else { return superRect }
        
        let lineHeight = font.lineHeight
        let yOffset = (superRect.size.height - lineHeight) / 2
        
        superRect.size.height = lineHeight
        superRect.origin.y += yOffset
        
        return superRect
    }
    
    func insertFormulaAttachment(_ view: MathFormula, at range: NSRange?) {
        let image = view.asImage()
        let textAttachment = TextAttachmentFactory.makeFormulaAttachment(
            image: image,
            font: font
        )
        textAttachment.isAccessibilityElement = true
        textAttachment.accessibilityLabel = view.content
        textAttachment.accessibilityTraits = .image
        
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)

        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
        
        let cursorPosition = range?.location ?? selectedRange.location
        if let range {
            mutableAttributedString.replaceCharacters(in: range, with: attrStringWithImage)
        } else {
            mutableAttributedString.insert(attrStringWithImage, at: cursorPosition)
        }
        mutableAttributedString.addAttributes([
            .formulaString : view.content
        ], range: NSRange(location: cursorPosition, length: attrStringWithImage.length))

        attributedText = mutableAttributedString
        font = .systemFont(ofSize: 20)

        // Putting the cursor right after inserting image
        selectedRange = NSMakeRange(cursorPosition + 1, 0)
    }
    
    private func setupView() {
        autocorrectionType = .no
        autocapitalizationType = .none
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .white
        textColor = .black
        font = .systemFont(ofSize: 20)
    }
}

// MARK: - NSAttributedString.Key

extension NSAttributedString.Key {
    static let formulaString = NSAttributedString.Key("formulaString")
}
