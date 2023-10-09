//
//  DocumentsModuleBuilder.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import Foundation

final class DocumentsModuleBuilder {
    
    func buildDefault() -> DocumentsView {
        let interactor = DocumentsDefaultInteractor()
        let presenter = DocumentsDefaultPresenter()
        let router = DocumentsDefaultRouter()
        let view = DocumentsDefaultView()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        router.presenter = presenter
        
        interactor.presenter = presenter
        
        return view
    }
}
