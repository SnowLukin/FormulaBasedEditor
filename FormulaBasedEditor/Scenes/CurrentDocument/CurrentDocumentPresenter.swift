//
//  CurrentDocumentPresenter.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol CurrentDocumentPresentationLogic {
    func presentDocumentTextView(withFrame frame: CGRect) -> CurrentDocumentTextView
    func presentDocumentTextViewToVC(documentTextView: CurrentDocumentTextView?)
    func presentEquationButton(viewModel: CurrentDocument.UIComponents.EquationButtonViewModel)
}

class CurrentDocumentPresenter: CurrentDocumentPresentationLogic {
    weak var viewController: CurrentDocumentDisplayLogic?
    
    func presentDocumentTextView(withFrame frame: CGRect) -> CurrentDocumentTextView {
        let documentTextView = CurrentDocumentTextViewFactory.makeDocumentTextView(withFrame: frame)
        return documentTextView
    }
    
    func presentDocumentTextViewToVC(documentTextView: CurrentDocumentTextView?) {
        guard let documentTextView = documentTextView else { return }
        viewController?.displayDocumentTextView(documentTextView: documentTextView)
    }
    
    func presentEquationButton(viewModel: CurrentDocument.UIComponents.EquationButtonViewModel) {
        viewController?.displayEquationButton(viewModel: viewModel)
    }
}
