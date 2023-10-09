//
//  DocumentDefaultView.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit
import SwiftUI

final class DocumentDefaultView: UIViewController, DocumentView {
    
    var presenter: DocumentPresenter?
    
    var document: Document?
    
    private lazy var documentTextView: CurrentDocumentTextView = {
        let view: CurrentDocumentTextView
        if #available(iOS 16.0, *) {
            view = .init(usingTextLayoutManager: false)
        } else {
            view = .init()
        }
        view.delegate = self
        
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var equationButton: EquationNavigationButton = {
        let button = EquationNavigationButton()
        button.addAction(UIAction { [weak self] _ in
            self?.presenter?.onNavigateToFormulaView(nil)
        }, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: equationButton)
    }
    
    func configure(with document: Document) {
        self.document = document
    }
    
    func setupViews() {
        updateView()
        documentTextView
            .safeAreaTop()
            .bottom()
            .leadingAndTrailing()
    }
    
    func setupAccessibility() {
        documentTextView.isAccessibilityElement = true
        documentTextView.accessibilityLabel = "Редактор текста"
        documentTextView.accessibilityTraits = .allowsDirectInteraction
        
        equationButton.isAccessibilityElement = true
        equationButton.accessibilityLabel = "Добавить формулу"
        equationButton.accessibilityTraits = .button
    }
    
    func updateView() {
        title = document?.title
        guard let text = document?.text else { return }
        documentTextView.attributedText = text
        documentTextView.font = .systemFont(ofSize: 20)
    }
    
    func insertFormula(_ formula: MathFormula, at range: NSRange? = nil) {
        documentTextView.insertFormulaAttachment(formula, at: range)
    }
}

extension DocumentDefaultView: FormulaOutput {
    func addAttachment(_ formula: MathFormula, at range: NSRange?) {
        presenter?.onInsertingFormula(formula, at: range)
        presenter?.onDocumentChanged(document, text: documentTextView.attributedText)
    }
}

extension DocumentDefaultView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter?.onDocumentChanged(document, text: textView.attributedText)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presenter?.onAttachmentInteraction(
            textView.attributedText,
            textAttachment: textAttachment,
            in: characterRange
        ) ?? false
    }
}

#Preview("DocumentModule"){
    UINavigationController(
        rootViewController: DocumentModuleBuilder().buildDefault()
    )
    .showPreview()
    .ignoresSafeArea()
}
