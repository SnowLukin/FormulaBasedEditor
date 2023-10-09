//
//  DocumentDefaultRouter.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

final class DocumentDefaultRouter: DocumentRouter {
    
    weak var presenter: DocumentPresenter?
    
    func navigateToFormulaView(_ content: FormulaContent?, view: (DocumentView & FormulaOutput)) {
        let vc = FormulaModuleBuilder().buildDefault()
        vc.delegate = view
        if let content {
            vc.configure(with: content.content, range: content.range)
        }
        let navVC = UINavigationController(rootViewController: vc)
        view.present(navVC, animated: true)
    }
}
