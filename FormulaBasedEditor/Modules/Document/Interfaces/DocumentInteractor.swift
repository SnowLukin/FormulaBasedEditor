//
//  DocumentInteractor.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

protocol DocumentInteractor {
    var presenter: DocumentPresenter? { get set }
    
    func updateDocument(_ document: Document?, with text: NSAttributedString?)
    func shouldInteractWithAttachment(
        _ attributedString: NSAttributedString?,
        textAttachment: NSTextAttachment,
        in characterRange: NSRange
    ) -> Bool
}
