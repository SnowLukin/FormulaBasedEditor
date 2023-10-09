//
//  TextAttachmentFactory.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 12.08.2023.
//

import UIKit

enum TextAttachmentFactory {
    static func makeFormulaAttachment(image: UIImage, font: UIFont?) -> FormulaTextAttachment {
        let textAttachment = FormulaTextAttachment()
        textAttachment.image = image
        textAttachment.font = font
        return textAttachment
    }
}
