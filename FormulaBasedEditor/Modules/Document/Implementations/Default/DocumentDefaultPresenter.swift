//
//  DocumentDefaultPresenter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

final class DocumentDefaultPresenter: DocumentPresenter {
    var router: DocumentRouter?
    var interactor: DocumentInteractor?
    weak var view: DocumentView?
    
    func onViewDidLoad() {
        view?.setupViews()
        view?.setupAccessibility()
    }
    
    func onNavigateToFormulaView(_ content: FormulaContent?) {
        guard let view = view as? (DocumentView & FormulaOutput) else { return }
        router?.navigateToFormulaView(content, view: view)
    }
    
    func onInsertingFormula(_ formula: MathFormula, at range: NSRange?) {
        self.view?.insertFormula(formula, at: range)
    }
    
    func onDocumentChanged(_ document: Document?, text: NSAttributedString?) {
        interactor?.updateDocument(document, with: text)
    }
    
    func onAttachmentInteraction(
        _ attributedString: NSAttributedString?,
        textAttachment: NSTextAttachment,
        in characterRange: NSRange
    ) -> Bool {
        interactor?.shouldInteractWithAttachment(
            attributedString,
            textAttachment: textAttachment,
            in: characterRange
        ) ?? false
    }
}
