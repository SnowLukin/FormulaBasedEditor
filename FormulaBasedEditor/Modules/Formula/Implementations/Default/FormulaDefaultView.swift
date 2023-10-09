//
//  FormulaDefaultView.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit
import SwiftUI

final class FormulaDefaultView: UIViewController, FormulaView {
    
    var presenter: FormulaPresenter?
    
    weak var delegate: FormulaOutput?
    
    private var range: NSRange?
    
    private let formulaTextView: FormulaTextView = {
        let view = FormulaTextView()
        view.font = .preferredFont(forTextStyle: .body)
        return view
    }()
    
    private lazy var renderButton: UIButton = {
        let button = FormulaRenderButton()
        
        button.addAction(UIAction { [weak self] _ in
            self?.presenter?.onRenderFormula(with: self?.formulaTextView.text)
        }, for: .touchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
    
    func configure(with content: String, range: NSRange) {
        self.formulaTextView.text = content
        self.formulaTextView.font = .preferredFont(forTextStyle: .body)
        self.range = range
    }
    
    func setupView() {
        view.addSubview(formulaTextView)
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        
        formulaTextView
            .safeAreaTop(16)
            .leadingAndTrailing(16)
            .fixedHeight(200)
        renderButton
            .topToBottom(of: formulaTextView, 16)
            .fixedHeight(60)
            .leadingAndTrailing(16)
    }
    
    func setupAccessibility() {
        formulaTextView.accessibilityLabel = "Текст формулы"
        
        renderButton.accessibilityLabel = "Вставить формулу"
        renderButton.accessibilityTraits = .button
    }
    
    func updateText(_ text: String) {
        self.formulaTextView.text = text
    }
    
    func renderAttachment(_ formula: MathFormula) {
        delegate?.addAttachment(formula, at: range)
    }
    
    func navigateBack() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func cancelTapped() {
        presenter?.onCancel()
    }
}

#Preview("FormulaDefaultModule") {
    UINavigationController(
        rootViewController: FormulaModuleBuilder().buildDefault()
    )
    .showPreview()
    .ignoresSafeArea()
}
