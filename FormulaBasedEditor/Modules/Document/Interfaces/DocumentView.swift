//
//  DocumentView.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

protocol DocumentView: AnyObject, UIViewController {
    var presenter: DocumentPresenter? { get set }
    
    func configure(with document: Document)
    func setupViews()
    func setupAccessibility()
    func insertFormula(_ formula: MathFormula, at range: NSRange?)
}
