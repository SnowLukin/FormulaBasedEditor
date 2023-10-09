//
//  DocumentsDefaultInteractor.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import Foundation

final class DocumentsDefaultInteractor: DocumentsInteractor {
    
    weak var presenter: DocumentsPresenter?
    
    func fetchDocuments() {
        let documents = fetchSortedDocuments()
        presenter?.updateDocumentList(with: documents)
    }
    
    func searchDocuments(_ text: String?) {
        var documents = fetchSortedDocuments()
        
        if let text, !text.isEmpty {
            documents = documents.filter { document in
                guard let title = document.title else { return true }
                return title.lowercased().contains(text.lowercased())
            }
        }
        presenter?.updateDocumentList(with: documents)
    }
    
    func addDocument(title: String) {
        let params = Document.Parameters(title: title, text: nil)
        DocumentStorageManager.shared.create(with: params)
        
        let documents = fetchSortedDocuments()
        presenter?.updateDocumentList(with: documents)
    }
    
    func deleteDocument(_ document: Document) {
        DocumentStorageManager.shared.delete(with: document.uuid)
    }
    
    func updateDocument(_ document: Document, title: String) {
        DocumentStorageManager.shared.update(
            uuid: document.uuid,
            with: .init(title: title, text: document.text)
        )
        
        let documents = fetchSortedDocuments()
        presenter?.updateDocumentList(with: documents)
    }
}

private extension DocumentsDefaultInteractor {
    func fetchSortedDocuments() -> [Document] {
        let documents = DocumentStorageManager.shared.fetchDocuments()
        let sortedDocuments = documents.sorted(by: { $0.wrappedLastEdit > $1.wrappedLastEdit })
        return sortedDocuments
    }
}
