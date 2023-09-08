//
//  DocumentsInteractor.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 28.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol DocumentsBusinessLogic {
}

protocol DocumentsDataStore {
}

class DocumentsInteractor: DocumentsBusinessLogic, DocumentsDataStore {
    var presenter: DocumentsPresentationLogic?
    var worker: DocumentsWorker?
    
}
