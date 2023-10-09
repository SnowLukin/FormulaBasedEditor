//
//  DocumentPresenter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

protocol DocumentPresenter: AnyObject {
    var router: DocumentRouter? { get set }
    var interactor: DocumentInteractor? { get set }
    var view: DocumentView? { get set }
    
    func onViewDidLoad()
    
    func onNavigateToFormulaView(_ content: FormulaContent?)
    func onInsertingFormula(_ formula: MathFormula, at range: NSRange?)
    func onDocumentChanged(_ document: Document?, text: NSAttributedString?)
    func onAttachmentInteraction(
        _ attributedString: NSAttributedString?,
        textAttachment: NSTextAttachment,
        in characterRange: NSRange
    ) -> Bool
}
