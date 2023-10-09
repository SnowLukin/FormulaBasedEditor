//
//  DocumentsRouter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import Foundation

protocol DocumentsRouter {
    var presenter: DocumentsPresenter? { get set }
    
    func navigateToCurrentDocument(_ document: Document)
}
