//
//  FormulaDefaultPresenter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import Foundation

final class FormulaDefaultPresenter: FormulaPresenter {
    
    var interactor: FormulaInteractor?
    var router: FormulaRouter?
    weak var view: FormulaView?
    
    func onViewDidLoad() {
        view?.setupView()
        view?.setupAccessibility()
    }
    
    func onRenderFormula(with text: String?) {
        interactor?.renderFormula(text: text)
    }
    
    func onCancel() {
        router?.navigateBack()
    }
    
    func addRenderedFormula(_ formula: MathFormula) {
        view?.renderAttachment(formula)
        router?.navigateBack()
    }
    
    func dismissView() {
        view?.navigateBack()
    }
}
