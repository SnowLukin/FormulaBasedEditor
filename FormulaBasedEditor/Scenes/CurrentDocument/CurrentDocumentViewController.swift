//
//  CurrentDocumentViewController.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol CurrentDocumentDisplayLogic: AnyObject {
    func configure(with document: Document)
    func displayDocumentTextView(documentTextView: CurrentDocumentTextView)
    func displayEquationButton(viewModel: CurrentDocument.UIComponents.EquationButtonViewModel)
}

class CurrentDocumentViewController: UIViewController, CurrentDocumentDisplayLogic {
    var interactor: CurrentDocumentBusinessLogic?
    var router: (NSObjectProtocol & CurrentDocumentRoutingLogic & CurrentDocumentDataPassing)?
    
    var documentTextView: CurrentDocumentTextView!
    
    var historyManager: TextHistoryManager? = TextHistoryManager()
    var undoBarButtonItem: UIBarButtonItem?

    private var document: Document?
    
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
        let interactor = CurrentDocumentInteractor()
        let presenter = CurrentDocumentPresenter()
        let router = CurrentDocumentRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }

    func configure(with document: Document) {
        self.document = document
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureDocumentTextView()
        configureEquationButton()
    }
    
    // MARK: Document TextView
    
    func displayDocumentTextView(documentTextView: CurrentDocumentTextView) {
        self.documentTextView = documentTextView
        view.addSubview(self.documentTextView)
    }
    
    private func configureDocumentTextView() {
        interactor?.setupDocumentTextView(frame: view.bounds)
        documentTextView.delegate = self
        documentTextView.attributedText = document?.text
    }
    
    // MARK: Equation Navigation Button
    typealias EquationButtonViewModel = CurrentDocument.UIComponents.EquationButtonViewModel

    func displayEquationButton(viewModel: EquationButtonViewModel) {
        let stackView = createStackView(with: viewModel)
        let equationButton = createEquationButton(with: stackView)
        equationButton.addTarget(self, action: #selector(insertFormulaTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: equationButton)
    }
    
    private func configureEquationButton() {
        interactor?.setupEquationButton()
    }

    private func createStackView(with viewModel: EquationButtonViewModel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = .systemBlue
        titleLabel.sizeToFit()
        
        let imageView = UIImageView(image: UIImage(systemName: viewModel.imageName))
        imageView.contentMode = .scaleAspectFit

        imageView
            .fixedWidth(20)
            .fixedHeight(20)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, imageView])
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }

    private func createEquationButton(with stackView: UIStackView) -> UIButton {
        let equationButton = UIButton(type: .system)
        equationButton.addSubview(stackView)
        stackView
            .fitToSuperview()
        return equationButton
    }
    
    @objc func insertFormulaTapped() {
        router?.navigateToFormulaViewController()
    }
}

extension CurrentDocumentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        historyManager?.registerChange(textView.text)
        undoBarButtonItem?.isEnabled = historyManager?.canUndo ?? false
    }
}

// MARK: FormulaRenderDelegate

extension CurrentDocumentViewController: FormulaRenderDelegate {
    func didRenderFormula(view: UIView) {
        let image = view.asImage()
        let textAttachment = TextAttachmentFactory.makeVCenteredAttachment(
            image: image,
            font: documentTextView.font
        )
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        let mutableAttributedString = NSMutableAttributedString(attributedString: documentTextView.attributedText)

        let cursorPosition = documentTextView.selectedRange.location
        mutableAttributedString.insert(attrStringWithImage, at: cursorPosition)

        documentTextView.attributedText = mutableAttributedString
        documentTextView.font = Constants.Formula.documentFont

        // Putting the cursor right after inserting image
        documentTextView.selectedRange = NSMakeRange(cursorPosition + 1, 0)
    }
}

extension CurrentDocumentViewController {
    private enum Constants {
        struct Formula {
            static let minOffsetHeight: CGFloat = 10
            static let documentFont: UIFont = .systemFont(ofSize: 20)
        }
    }
}
