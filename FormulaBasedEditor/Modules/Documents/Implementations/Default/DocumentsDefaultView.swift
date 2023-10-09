//
//  DocumentsDefaultView.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import UIKit
import SwiftUI


final class DocumentsDefaultView: UIViewController, DocumentsView {
    
    var presenter: DocumentsPresenter?
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = " Поиск..."
        controller.searchResultsUpdater = self
        navigationItem.searchController = controller
        return controller
    }()
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var emptyListLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока пусто :("
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var addDocumentButton: AddDocumentButton = {
        let button = AddDocumentButton()
        button.delegate = self
        
        bottomBar.addSubview(button)
        return button
    }()
    
    private lazy var documentsCollection: DocumentsCollectionView = {
        let view = DocumentsCollectionView()
        view.delegate = self
        view.output = self
        
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }
    
    func setupViews() {
        title = "Документы"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        documentsCollection
            .fitToSuperview()
        emptyListLabel
            .centerVertically()
            .centerHorizontally()
        bottomBar
            .fixedHeight(100)
            .leadingAndTrailing()
            .bottom()
        addDocumentButton
            .fixedHeight(40)
            .fixedWidth(40)
            .trailing(20)
            .top(10)
    }
    
    func setupAccessibility() {
        emptyListLabel.isAccessibilityElement = true
        emptyListLabel.accessibilityLabel = "Пустой список."
        emptyListLabel.accessibilityTraits = .staticText
        
        addDocumentButton.isAccessibilityElement = true
        addDocumentButton.accessibilityLabel = "Создать документ."
        addDocumentButton.accessibilityTraits = .button
        
        searchController.isAccessibilityElement = true
        searchController.accessibilityLabel = "Поиск документов."
        searchController.accessibilityTraits = .searchField
    }
    
    func updateDocuments(with documents: [Document]) {
        emptyListLabel.isHidden = !documents.isEmpty
        documentsCollection.isScrollEnabled = !documents.isEmpty
        documentsCollection.configure(with: documents, animated: true)
        documentsCollection.reloadData()
    }
    
    func showEditAlert(for document: Document) {
        let ac = UIAlertController(
            title: "Новое имя документа",
            message: nil,
            preferredStyle: .alert
        )
        ac.addTextField()
        
        let submitAction = UIAlertAction(
            title: "Сохранить",
            style: .default
        ) { [unowned ac] _ in
            let textField = ac.textFields![0]
            let name = textField.text ?? ""
            self.presenter?.onDocumentFinishEdit(document, newName: name)
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
}

extension DocumentsDefaultView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        presenter?.onUpdateSearch(text)
    }
}

extension DocumentsDefaultView: AddDocumentDelegate {
    func onDocumentAddTapped(title: String) {
        presenter?.onDocumentAddTapped(title: title)
    }
}

extension DocumentsDefaultView: UICollectionViewDelegate, DocumentsCollectionOutput {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        documentsCollection.deselectItem(at: indexPath, animated: true)
        guard let document = documentsCollection.item(for: indexPath) else { return }
        presenter?.onNavigationToCurrentDocument(document)
    }
    
    func onDocumentEdit(_ document: Document) {
        presenter?.onDocumentStartEdit(document)
    }
    
    func onDocumentDelete(_ document: Document) {
        presenter?.onDocumentDelete(document)
    }
}


#Preview("DocumentsDefaultModule") {
    UINavigationController(
        rootViewController: DocumentsModuleBuilder().buildDefault()
    )
    .showPreview()
    .ignoresSafeArea()
}
