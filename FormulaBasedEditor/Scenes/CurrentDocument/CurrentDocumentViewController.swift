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
}

final class CurrentDocumentViewController: UIViewController, CurrentDocumentDisplayLogic {
    
    typealias EquationButtonViewModel = CurrentDocument.UIComponents.EquationButtonViewModel
    
    var interactor: CurrentDocumentBusinessLogic?
    var router: (NSObjectProtocol & CurrentDocumentRoutingLogic & CurrentDocumentDataPassing)?
    
    private let documentTextView: CurrentDocumentTextView = {
        let documentTextView: CurrentDocumentTextView
        if #available(iOS 16.0, *) {
            documentTextView = CurrentDocumentTextView(usingTextLayoutManager: false)
        } else {
            documentTextView = CurrentDocumentTextView()
        }
        documentTextView.autocorrectionType = .no
        documentTextView.autocapitalizationType = .none
        documentTextView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        documentTextView.backgroundColor = .white
        documentTextView.textColor = .black
        documentTextView.font = .systemFont(ofSize: 20)
        return documentTextView
    }()
    
    private let equationTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Формула"
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = .systemBlue
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    private let equationImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "x.squareroot"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let equationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private let equationButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
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
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        configureDocumentTextView()
        configureEquationButton()
        setupAccessibility()
    }
    
    // MARK: Public
    
    // MARK: Private
    
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
    
    private func configureDocumentTextView() {
        documentTextView.delegate = self
        view.addSubview(documentTextView)
        
        documentTextView
            .safeAreaTop()
            .bottom()
            .leadingAndTrailing()
    }
    
    private func configureEquationButton() {
        equationButton.addSubview(equationStackView)
        equationStackView.addArrangedSubviews(equationTitleLabel, equationImage)
        
        equationStackView
            .fitToSuperview()
        equationImage
            .fixedWidth(20)
            .fixedHeight(20)
        
        equationButton.addTarget(self, action: #selector(insertFormulaTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: equationButton)
    }
    
    private func saveText() {
        guard let document else { return }
        DocumentStorageManager.shared.update(
            uuid: document.uuid,
            with: .init(
                title: document.title ?? "",
                text: documentTextView.attributedText
            )
        )
    }
    
    private func setupAccessibility() {
        documentTextView.isAccessibilityElement = true
        documentTextView.accessibilityIdentifier = "CurrentDocumentAccessibility.documentTextView"
        documentTextView.accessibilityLabel = "Редактор текста."
        documentTextView.accessibilityValue = "Здесь находится ваш текст."
        documentTextView.accessibilityHint = "Введите ваш текст."
        documentTextView.accessibilityTraits = .allowsDirectInteraction
        
        equationButton.isAccessibilityElement = true
        equationButton.accessibilityIdentifier = "CurrentDocumentAccessibility.equationButton"
        equationButton.accessibilityLabel = "Добавить формулу."
        equationButton.accessibilityValue = "По нажатию откроется окно с вводом формулы."
        equationButton.accessibilityHint = "Нажмите чтобы открыть окно добавление формулы."
        equationButton.accessibilityTraits = .button
        
        let backButton = navigationItem.leftBarButtonItem
        backButton?.isAccessibilityElement = true
        backButton?.accessibilityLabel = "Назад."
        backButton?.accessibilityValue = "По нажатию откроется список документов."
        backButton?.accessibilityHint = "Нажмите чтобы перейти назад к списку документов."
        backButton?.accessibilityTraits = .button
    }
    
    @objc func insertFormulaTapped() {
        router?.navigateToFormulaViewController(with: nil)
    }
}

// MARk: CurrentDocumentDisplayLogic

extension CurrentDocumentViewController {
    
    func configure(with document: Document) {
        self.document = document
        title = document.title
        guard let text = document.text else { return }
        documentTextView.attributedText = text
    }
}

// MARK: - UITextViewDelegate

extension CurrentDocumentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        saveText()
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let attributedString = textView.attributedText else {
            print("Couldnt find attributed string.")
            return true
        }
        guard textAttachment is FormulaTextAttachment else {
            print("Interacted with NON formula attachment.")
            return true
        }
        print("Interacted with formula attachment.")
        let attributes = attributedString.attributes(at: characterRange.location, effectiveRange: nil)
        
        guard let formulaString = attributes[.formulaString] as? String else {
            print("Couldnt find formula string.")
            return false
        }
        print("Formula String: \(formulaString)")
        router?.navigateToFormulaViewController(with: .init(content: formulaString, range: characterRange))
        return true
    }
}

// MARK: - FormulaRenderDelegate

extension CurrentDocumentViewController: FormulaRenderDelegate {
    func addFormulaAttachment(_ view: FormulaViewProtocol, at range: NSRange? = nil) {
        let image = view.asImage()
        let textAttachment = TextAttachmentFactory.makeFormulaAttachment(
            image: image,
            font: documentTextView.font
        )
        
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)

        let mutableAttributedString = NSMutableAttributedString(attributedString: documentTextView.attributedText)
        
        let cursorPosition = range?.location ?? documentTextView.selectedRange.location
        if let range {
            mutableAttributedString.replaceCharacters(in: range, with: attrStringWithImage)
        } else {
            mutableAttributedString.insert(attrStringWithImage, at: cursorPosition)
        }
        mutableAttributedString.addAttributes([
            .formulaString : view.content
        ], range: NSRange(location: cursorPosition, length: attrStringWithImage.length))

        documentTextView.attributedText = mutableAttributedString
        documentTextView.font = Constants.Formula.documentFont

        // Putting the cursor right after inserting image
        documentTextView.selectedRange = NSMakeRange(cursorPosition + 1, 0)
        
        saveText()
    }
}


// MARK: - Constants

extension CurrentDocumentViewController {
    private enum Constants {
        struct Formula {
            static let minOffsetHeight: CGFloat = 10
            static let documentFont: UIFont = .systemFont(ofSize: 20)
        }
    }
}

// MARK: - NSAttributedString.Key

extension NSAttributedString.Key {
    static let formulaString = NSAttributedString.Key("formulaString")
}
