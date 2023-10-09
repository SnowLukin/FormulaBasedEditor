//
//  DocumentRouter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import Foundation

protocol DocumentRouter {
    var presenter: DocumentPresenter? { get set }
    
    func navigateToFormulaView(
        _ content: FormulaContent?,
        view: (DocumentView & FormulaOutput)
    )
}
