//
//  DocumentsPresenter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import Foundation

protocol DocumentsPresenter: AnyObject {
    var router: DocumentsRouter? { get set }
    var interactor: DocumentsInteractor? { get set }
    var view: DocumentsView? { get set }
    
    func onViewWillAppear()
    func onViewDidLoad()
    func onFetchedRequest()
    func onUpdateSearch(_ text: String?)
    func onDocumentAddTapped(title: String)
    func onNavigationToCurrentDocument(_ document: Document)
    func onDocumentDelete(_ document: Document)
    func onDocumentStartEdit(_ document: Document)
    func onDocumentFinishEdit(_ document: Document, newName: String)
    
    func updateDocumentList(with documents: [Document])
}
