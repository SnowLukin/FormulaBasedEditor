//
//  FormulaView.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

protocol FormulaView: UIViewController {
    var presenter: FormulaPresenter? { get set }
    var delegate: FormulaOutput? { get set }
    
    func configure(with content: String, range: NSRange)
    func setupView()
    func setupAccessibility()
    func renderAttachment(_ formula: MathFormula)
    func navigateBack()
}
