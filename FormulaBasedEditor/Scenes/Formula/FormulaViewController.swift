//
//  FormulaViewController.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 27.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol FormulaDisplayLogic: AnyObject {
    func addFormulaAttachment(_ view: FormulaViewProtocol)
}

protocol FormulaRenderDelegate: AnyObject {
    func addFormulaAttachment(_ view: FormulaViewProtocol, at range: NSRange?)
}

final class FormulaViewController: UIViewController, FormulaDisplayLogic {
    var interactor: FormulaBusinessLogic?
    var router: (NSObjectProtocol & FormulaRoutingLogic & FormulaDataPassing)?
    
    weak var delegate: FormulaRenderDelegate?
    
    let formulaTextView = UITextView()
    let renderButton = UIButton(type: .system)
    private var range: NSRange?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let viewController = self
        let interactor = FormulaInteractor()
        let presenter = FormulaPresenter()
        let router = FormulaRouter()
        let worker = FormulaWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Редактор формул"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        
        setupFormulaTextView()
        setupRenderButton()
        setupAccessibility()
    }
    
    func configure(with content: String, range: NSRange) {
        formulaTextView.text = content
        self.range = range
    }
    
    func addFormulaAttachment(_ view: FormulaViewProtocol) {
        delegate?.addFormulaAttachment(view, at: range)
    }
    
    private func setupFormulaTextView() {
        formulaTextView.layer.cornerRadius = 10
        formulaTextView.layer.borderWidth = 1
        formulaTextView.layer.borderColor = UIColor.lightGray.cgColor
        formulaTextView.backgroundColor = .white
        formulaTextView.textColor = .black
        formulaTextView.autocorrectionType = .no
        formulaTextView.autocapitalizationType = .none
        formulaTextView.font = .systemFont(ofSize: 16)
        view.addSubview(formulaTextView)
        
        formulaTextView
            .safeAreaTop(16)
            .leadingAndTrailing(16)
            .fixedHeight(100)
    }
    
    private func setupRenderButton() {
        renderButton.setTitle("Вставить формулу", for: .normal)
        renderButton.titleLabel?.font = .boldSystemFont(ofSize: renderButton.titleLabel?.font.pointSize ?? 18)
        renderButton.backgroundColor = .secondarySystemBackground
        renderButton.addTarget(self, action: #selector(renderTapped), for: .touchUpInside)
        
        view.addSubview(renderButton)
        
        renderButton
            .topToBottom(of: formulaTextView, 16)
            .fixedHeight(60)
            .leadingAndTrailing()
    }
    
    private func setupAccessibility() {
        formulaTextView.isAccessibilityElement = true
        formulaTextView.accessibilityIdentifier = "FormulaAccessibility.formulaTextView"
        formulaTextView.accessibilityLabel = "Текст формулы."
        formulaTextView.accessibilityValue = "Ваш текст формулы."
        formulaTextView.accessibilityHint = "Введите вашу формулу привычным вам способом."
        formulaTextView.accessibilityTraits = .allowsDirectInteraction
        
        renderButton.isAccessibilityElement = true
        renderButton.accessibilityIdentifier = "FormulaAccessibility.renderButton"
        renderButton.accessibilityLabel = "Вставить формулу."
        renderButton.accessibilityValue = "По нажатию произойдет переход в редактор и вставка в него формулы."
        renderButton.accessibilityHint = "Нажмите, чтобы вставить введенную формулу в редактор."
        renderButton.accessibilityTraits = .button
        
        let cancelButton = navigationItem.rightBarButtonItem
        cancelButton?.isAccessibilityElement = true
        cancelButton?.accessibilityLabel = "Назад."
        cancelButton?.accessibilityValue = "По нажатию произойдет переход в редактор."
        cancelButton?.accessibilityHint = "Нажмите, чтобы отменить ввод формулы и перейтти назад в редактор текста."
        cancelButton?.accessibilityTraits = .button
    }
    
    @objc func cancelTapped() {
        router?.navigateBack()
    }
    
    @objc func renderTapped() {
        guard let text = formulaTextView.text else { return }
        interactor?.renderFormula(text: text)
        router?.navigateBack()
    }
}
