//
//  DocumentsInteractor.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 28.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol DocumentsBusinessLogic {
    func saveDocument(request: Documents.Save.Request)
    func fetchDocuments(request: Documents.Fetch.Request)
}

protocol DocumentsDataStore {
    var documents: [Documents.Entity] { get }
}

class DocumentsInteractor: DocumentsBusinessLogic, DocumentsDataStore {
    var presenter: DocumentsPresentationLogic?
    var worker: DocumentsWorker?
    
    var documents: [Documents.Entity] = []
    
    func saveDocument(request: Documents.Save.Request) {
        var document = Documents.Entity(
            title: request.title,
            date: Date(),
            attributedString: request.attributedString,
            text: request.text
        )
        let newAttributedString = worker?.saveImagesInAttributedString(
            attributedString: document.attributedString
        )
        let data = try? NSKeyedArchiver.archivedData(
            withRootObject: newAttributedString as Any,
            requiringSecureCoding: false
        )
        guard let data else {
            print("DocumentsInteractor: failed to save Document")
            return
        }
        document.text = data
        worker?.saveDocument(document: document)
    }
    
    func fetchDocuments(request: Documents.Fetch.Request) {
        documents = worker?.fetchDocuments() ?? []
        let response = Documents.Fetch.Response(documents: documents)
        presenter?.presentFetchedDocuments(response: response)
    }
}
