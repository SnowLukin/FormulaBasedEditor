//
//  DocumentsView.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import UIKit

protocol DocumentsView: AnyObject, UIViewController {
    var presenter: DocumentsPresenter? { get set }
    
    func setupViews()
    func setupAccessibility()
    func updateDocuments(with documents: [Document])
    func showEditAlert(for document: Document)
}
