//
//  FormulaDefaultInteractor.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import Foundation

final class FormulaDefaultInteractor: FormulaInteractor {
    
    weak var presenter: FormulaPresenter?
    
    func renderFormula(text: String?) {
        let formulaView = FormulaFactory.createFormulaView(for: text ?? "")
        presenter?.addRenderedFormula(formulaView)
    }
}
