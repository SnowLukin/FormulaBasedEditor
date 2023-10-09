//
//  FormulaPresenter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import Foundation

protocol FormulaPresenter: AnyObject {
    var interactor: FormulaInteractor? { get set }
    var router: FormulaRouter? { get set }
    var view: FormulaView? { get set }
    
    func onViewDidLoad()
    func onRenderFormula(with text: String?)
    func onCancel()
    
    func addRenderedFormula(_ formula: MathFormula)
    func dismissView()
}
