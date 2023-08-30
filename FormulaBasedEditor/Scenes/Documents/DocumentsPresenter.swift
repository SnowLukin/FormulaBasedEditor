//
//  DocumentsPresenter.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 28.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol DocumentsPresentationLogic {
    func presentFetchedDocuments(response: Documents.Fetch.Response)
}

class DocumentsPresenter: DocumentsPresentationLogic {
    weak var viewController: DocumentsDisplayLogic?
    
    func presentFetchedDocuments(response: Documents.Fetch.Response) {

//        viewController?.displayFetchedDocuments(viewModel: viewModel)
    }
}
