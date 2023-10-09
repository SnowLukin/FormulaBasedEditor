//
//  DocumentsDefaultPresenter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import Foundation

final class DocumentsDefaultPresenter: DocumentsPresenter {
    
    var interactor: DocumentsInteractor?
    var router: DocumentsRouter?
    weak var view: DocumentsView?
    
    func onViewWillAppear() {
        interactor?.fetchDocuments()
    }
    
    func onViewDidLoad() {
        view?.setupViews()
        view?.setupAccessibility()
        interactor?.fetchDocuments()
    }
    
    func onFetchedRequest() {
        interactor?.fetchDocuments()
    }
    
    func onUpdateSearch(_ text: String?) {
        interactor?.searchDocuments(text)
    }
    
    func onDocumentAddTapped(title: String) {
        interactor?.addDocument(title: title)
    }
    
    func onNavigationToCurrentDocument(_ document: Document) {
        router?.navigateToCurrentDocument(document)
    }
    
    func onDocumentDelete(_ document: Document) {
        interactor?.deleteDocument(document)
    }
    
    func onDocumentStartEdit(_ document: Document) {
        view?.showEditAlert(for: document)
    }
    
    func onDocumentFinishEdit(_ document: Document, newName: String) {
        interactor?.updateDocument(document, title: newName)
    }
    
    func updateDocumentList(with documents: [Document]) {
        view?.updateDocuments(with: documents)
    }
}
