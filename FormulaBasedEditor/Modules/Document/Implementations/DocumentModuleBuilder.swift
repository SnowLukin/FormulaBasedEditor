//
//  DocumentModuleBuilder.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import Foundation

final class DocumentModuleBuilder {
    func buildDefault() -> DocumentView {
        let interactor = DocumentDefaultInteractor()
        let presenter = DocumentDefaultPresenter()
        let router = DocumentDefaultRouter()
        let view = DocumentDefaultView()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        router.presenter = presenter
        
        interactor.presenter = presenter
        
        return view
    }
}
