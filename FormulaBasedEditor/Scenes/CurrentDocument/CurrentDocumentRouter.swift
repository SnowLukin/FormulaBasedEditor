//
//  CurrentDocumentRouter.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol CurrentDocumentRoutingLogic {
    func navigateToFormulaViewController(with params: CurrentDocument.FormulaParameters.Content?)
}

protocol CurrentDocumentDataPassing {
    var dataStore: CurrentDocumentDataStore? { get }
}

class CurrentDocumentRouter: NSObject, CurrentDocumentRoutingLogic, CurrentDocumentDataPassing {
    weak var viewController: CurrentDocumentViewController?
    var dataStore: CurrentDocumentDataStore?
    
    func navigateToFormulaViewController(with params: CurrentDocument.FormulaParameters.Content? = nil) {
        let formulaViewController = FormulaViewController()
        formulaViewController.delegate = viewController
        if let params {
            formulaViewController.configure(with: params.content, range: params.range)
        }
        let navigationController = UINavigationController(rootViewController: formulaViewController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
