//
//  FormulaRouter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import Foundation

protocol FormulaRouter {
    var presenter: FormulaPresenter? { get set }
    
    func navigateBack()
}
