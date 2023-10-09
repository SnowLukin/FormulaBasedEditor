//
//  FormulaDefaultRouter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import Foundation

final class FormulaDefaultRouter: FormulaRouter {
    weak var presenter: FormulaPresenter?
    
    func navigateBack() {
        presenter?.dismissView()
    }
}
