//
//  CurrentDocumentRouter.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol CurrentDocumentRoutingLogic {
    func navigateToFormulaViewController()
}

protocol CurrentDocumentDataPassing {
    var dataStore: CurrentDocumentDataStore? { get }
}

class CurrentDocumentRouter: NSObject, CurrentDocumentRoutingLogic, CurrentDocumentDataPassing {
    weak var viewController: CurrentDocumentViewController?
    var dataStore: CurrentDocumentDataStore?
    
    func navigateToFormulaViewController() {
        let formulaViewController = FormulaViewController()
        formulaViewController.delegate = viewController
        viewController?.present(formulaViewController, animated: true, completion: nil)
    }
}
