//
//  FormulaInteractor.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import Foundation

protocol FormulaInteractor {
    var presenter: FormulaPresenter? { get set }
    
    func renderFormula(text: String?)
}
