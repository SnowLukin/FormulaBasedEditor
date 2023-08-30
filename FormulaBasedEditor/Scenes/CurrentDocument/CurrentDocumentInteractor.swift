//
//  CurrentDocumentInteractor.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol CurrentDocumentBusinessLogic {
    func setupDocumentTextView(frame: CGRect)
    func setupEquationButton()
}

protocol CurrentDocumentDataStore {
    
}

class CurrentDocumentInteractor: CurrentDocumentBusinessLogic, CurrentDocumentDataStore {
    var presenter: CurrentDocumentPresentationLogic?
    var worker: CurrentDocumentWorker?
    
    func setupDocumentTextView(frame: CGRect) {
        let documentTextView = presenter?.presentDocumentTextView(withFrame: frame)
        presenter?.presentDocumentTextViewToVC(documentTextView: documentTextView)
    }
    
    func setupEquationButton() {
        let viewModel = CurrentDocument.UIComponents.EquationButtonViewModel(title: "Equation", imageName: "x.squareroot")
        presenter?.presentEquationButton(viewModel: viewModel)
    }
}
