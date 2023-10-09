//
//  DocumentsInteractor.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import Foundation

protocol DocumentsInteractor {
    var presenter: DocumentsPresenter? { get set }
    
    func fetchDocuments()
    func searchDocuments(_ text: String?)
    func addDocument(title: String)
    func deleteDocument(_ document: Document)
    func updateDocument(_ document: Document, title: String)
}
