//
//  FormulaPresenter.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 27.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol FormulaPresentationLogic {
    func presentRenderedFormula(view: UIView)
}

class FormulaPresenter: FormulaPresentationLogic {
    weak var viewController: FormulaDisplayLogic?

    func presentRenderedFormula(view: UIView) {
        viewController?.displayRenderedFormula(view: view)
    }
}
