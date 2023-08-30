//
//  TextAttachmentFactory.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 12.08.2023.
//

import UIKit

enum TextAttachmentFactory {
    static func makeVCenteredAttachment(image: UIImage, font: UIFont?) -> NSTextAttachment {
        let textAttachment = VerticallyCenteredTextAttachment()
        textAttachment.image = image
        textAttachment.font = font
        return textAttachment
    }
}
