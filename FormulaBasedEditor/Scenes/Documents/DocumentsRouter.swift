//
//  DocumentsRouter.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 28.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol DocumentsRoutingLogic {
}

protocol DocumentsDataPassing {
    var dataStore: DocumentsDataStore? { get }
}

class DocumentsRouter: NSObject, DocumentsRoutingLogic, DocumentsDataPassing {
    weak var viewController: DocumentsViewController?
    var dataStore: DocumentsDataStore?
    
}
