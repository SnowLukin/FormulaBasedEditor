//
//  DocumentsDefaultRouter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import Foundation

final class DocumentsDefaultRouter: DocumentsRouter {
    weak var presenter: DocumentsPresenter?
    
    func navigateToCurrentDocument(_ document: Document) {
        let vc = DocumentModuleBuilder().buildDefault()
//        let vc = CurrentDocumentViewController()
        vc.configure(with: document)
        presenter?.view?.navigationController?.pushViewController(vc, animated: true)
    }
}
