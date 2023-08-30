//
//  FormulaInteractor.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 27.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol FormulaBusinessLogic {
    func renderFormula(text: String)
}

protocol FormulaDataStore {
    
}

class FormulaInteractor: FormulaBusinessLogic, FormulaDataStore {
    var presenter: FormulaPresentationLogic?
    var worker: FormulaWorker?

    func renderFormula(text: String) {
        guard let formulaView = worker?.renderFormulaView(with: text) else { return }
        presenter?.presentRenderedFormula(view: formulaView)
    }
}
