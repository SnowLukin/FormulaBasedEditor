//
//  FormulaRouter.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 27.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol FormulaRoutingLogic {
    func navigateBack()
}

protocol FormulaDataPassing {
    var dataStore: FormulaDataStore? { get }
}

final class FormulaRouter: NSObject, FormulaRoutingLogic, FormulaDataPassing {
    weak var viewController: FormulaViewController?
    var dataStore: FormulaDataStore?
    
    func navigateBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
