//
//  FormulaViewController.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 27.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol FormulaDisplayLogic: AnyObject {
    func displayRenderedFormula(view: UIView)
}

protocol FormulaRenderDelegate: AnyObject {
    func didRenderFormula(view: UIView)
}

class FormulaViewController: UIViewController, FormulaDisplayLogic {
    var interactor: FormulaBusinessLogic?
    var router: (NSObjectProtocol & FormulaRoutingLogic & FormulaDataPassing)?
    
    weak var delegate: FormulaRenderDelegate?
    
    let formulaTextView = UITextView()
    let renderButton = UIButton(type: .system)
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
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
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Type Formula"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        setupFormulaTextView()
        setupRenderButton()
    }
    
    private func setupFormulaTextView() {
        formulaTextView.autocorrectionType = .no
        formulaTextView.autocapitalizationType = .none
        formulaTextView.translatesAutoresizingMaskIntoConstraints = false
        formulaTextView.font = .systemFont(ofSize: 16)
        view.addSubview(formulaTextView)
        NSLayoutConstraint.activate([
            formulaTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            formulaTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formulaTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            formulaTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupRenderButton() {
        renderButton.setTitle("Render Formula", for: .normal)
        renderButton.addTarget(self, action: #selector(renderTapped), for: .touchUpInside)
        renderButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderButton)
        NSLayoutConstraint.activate([
            renderButton.topAnchor.constraint(equalTo: formulaTextView.bottomAnchor, constant: 16),
            renderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func cancelTapped() {
        router?.navigateBack()
    }
    
    @objc func renderTapped() {
        guard let text = formulaTextView.text else { return }
        interactor?.renderFormula(text: text)
        router?.navigateBack()
    }

    func displayRenderedFormula(view: UIView) {
        delegate?.didRenderFormula(view: view)
    }
}
