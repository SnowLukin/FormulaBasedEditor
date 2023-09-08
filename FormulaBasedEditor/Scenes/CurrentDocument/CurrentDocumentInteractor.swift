//
//  CurrentDocumentInteractor.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol CurrentDocumentBusinessLogic {
}

protocol CurrentDocumentDataStore {
    
}

class CurrentDocumentInteractor: CurrentDocumentBusinessLogic, CurrentDocumentDataStore {
    var presenter: CurrentDocumentPresentationLogic?
    var worker: CurrentDocumentWorker?
    
}
