//
//  FormulaModuleBuilder.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 09.10.2023.
//

import Foundation

final class FormulaModuleBuilder {
    func buildDefault() -> FormulaView {
        let interactor = FormulaDefaultInteractor()
        let presenter = FormulaDefaultPresenter()
        let router = FormulaDefaultRouter()
        let view = FormulaDefaultView()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        router.presenter = presenter
        
        interactor.presenter = presenter
        
        return view
    }
}
