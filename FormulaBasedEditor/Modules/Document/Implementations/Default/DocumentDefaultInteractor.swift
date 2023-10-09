//
//  DocumentDefaultInteractor.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

final class DocumentDefaultInteractor: DocumentInteractor {
    weak var presenter: DocumentPresenter?
    
    func updateDocument(_ document: Document?, with text: NSAttributedString?) {
        guard let document else { return }
        DocumentStorageManager.shared.update(
            uuid: document.uuid,
            with: .init(
                title: document.title ?? "",
                text: text
            )
        )
    }
    
    func shouldInteractWithAttachment(
        _ attributedString: NSAttributedString?,
        textAttachment: NSTextAttachment,
        in characterRange: NSRange
    ) -> Bool {
        guard let attributedString else {
            debugPrint("Couldnt find attributed string.")
            return true
        }
        guard textAttachment is FormulaTextAttachment else {
            debugPrint("Interacted with NON formula attachment.")
            return true
        }
        debugPrint("Interacted with formula attachment.")
        let attributes = attributedString.attributes(at: characterRange.location, effectiveRange: nil)
        
        guard let formulaString = attributes[.formulaString] as? String else {
            debugPrint("Couldnt find formula string.")
            return false
        }
        debugPrint("Formula String: \(formulaString)")
        presenter?.onNavigateToFormulaView(.init(content: formulaString, range: characterRange))
        return true
    }
}
