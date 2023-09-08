//
//  DocumentsViewController.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 28.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

protocol DocumentsDisplayLogic: AnyObject {
    func fetchDocuments()
}

class DocumentsViewController: UIViewController, DocumentsDisplayLogic {
    var interactor: DocumentsBusinessLogic?
    var router: (NSObjectProtocol & DocumentsRoutingLogic & DocumentsDataPassing)?
    
    weak var addDocumentAlertAction : UIAlertAction?

    private var documents: [Document] = []
    private var searchedDocuments: [Document] = []

    private let documentsTableView = UITableView(frame: .zero, style: .insetGrouped)
    private let searchController = UISearchController()

    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    private let addDocumentButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 5
        configuration.image = UIImage(systemName: "square.and.pencil")
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

    private let emptyListLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока пусто :("
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAccessibility()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Документы"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        documentsTableView.setEditing(editing, animated: true)
        self.editButtonItem.title = editing ? "Готово" : "Изменить"
    }

    // MARK: Public

    func fetchDocuments() {
        let documents = DocumentStorageManager.shared.fetchDocuments()
        self.documents = documents.sorted(by: { $0.wrappedLastEdit > $1.wrappedLastEdit })
        searchedDocuments = self.documents
    }

    // MARK: Private
    
    private func setup() {
        let interactor = DocumentsInteractor()
        let presenter = DocumentsPresenter()
        let router = DocumentsRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }

    private func setupViews() {
        view.addSubviews(documentsTableView, emptyListLabel, bottomBar)
        bottomBar.addSubview(addDocumentButton)
        updateView()
        setupTableView()
        setupAddDocumentButton()
        setupSearchController()

        documentsTableView
            .fitToSuperview()
        bottomBar
            .fixedHeight(100)
            .leadingAndTrailing()
            .bottom()
        addDocumentButton
            .fixedHeight(40)
            .fixedWidth(40)
            .trailing(20)
            .top(10)
        emptyListLabel
            .centerVertically()
            .centerHorizontally()
    }

    private func setupTableView() {
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.rightBarButtonItem?.title = "Изменить"
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        documentsTableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: DocumentTableViewCell.reuseIdentifier)
    }

    private func setupAddDocumentButton() {
        addDocumentButton.addTarget(self, action: #selector(addDocumentButtonTapped), for: .touchUpInside)
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = " Поиск..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func updateView() {
        fetchDocuments()
        emptyListLabel.isHidden = !documents.isEmpty
        documentsTableView.isScrollEnabled = !documents.isEmpty
        documentsTableView.reloadData()
    }
    
    private func setupAccessibility() {
        emptyListLabel.isAccessibilityElement = true
        emptyListLabel.accessibilityIdentifier = "DocumentsAccessibility.emptyListLabel"
        emptyListLabel.accessibilityLabel = "Пустой список."
        emptyListLabel.accessibilityHint = "Список пуст. Добавьте документы."
        emptyListLabel.accessibilityTraits = .staticText
        
        addDocumentButton.isAccessibilityElement = true
        addDocumentButton.accessibilityIdentifier = "DocumentsAccessibility.addDocumentButton"
        addDocumentButton.accessibilityLabel = "Создать документ."
        addDocumentButton.accessibilityValue = "По нажатию откроется окно ввода названия документа."
        addDocumentButton.accessibilityHint = "Нажмите чтобы создать новый документ."
        addDocumentButton.accessibilityTraits = .button
        
        searchController.isAccessibilityElement = true
        searchController.accessibilityLabel = "Поиск документов."
        searchController.accessibilityHint = "Нажмите чтобы выполнить поиск документов по названию."
        searchController.accessibilityTraits = .searchField
    }

    @objc func addDocumentButtonTapped() {
        let alertController = UIAlertController(
            title: "Новый документ",
            message: "Введите название документа",
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.placeholder = "Имя документа"
            textField.addTarget(self, action: #selector(self.alertTextDidChanged), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)

        let submitAction = UIAlertAction(title: "Создать", style: .default) { [unowned alertController] _ in
            let answer = alertController.textFields![0]
            guard let title = answer.text else { return }
            let params = Document.Parameters(title: title, text: nil)
            DocumentStorageManager.shared.create(with: params)
            self.updateView()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        self.addDocumentAlertAction = submitAction
        addDocumentAlertAction?.isEnabled = false

        present(alertController, animated: true)
    }
    
    @objc func alertTextDidChanged(_ sender: UITextField) {
        let trimmedText = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            let text = trimmedText,
            !text.isEmpty,
            !documents.contains(where: { $0.title == text })
        else {
            addDocumentAlertAction?.accessibilityValue = "Неактивная кнопка. Имя документа должно быть уникально и не быть пустой строкой."
            addDocumentAlertAction?.isEnabled = false
            return
        }
        addDocumentAlertAction?.isEnabled = true
        addDocumentAlertAction?.accessibilityValue = nil
    }
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedDocuments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.reuseIdentifier, for: indexPath) as? DocumentTableViewCell else { return UITableViewCell() }
        let document = searchedDocuments[indexPath.row]
        cell.configure(title: document.title ?? "", subtitle: document.wrappedLastEdit.formatedString())
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrentDocumentViewController()
        let document = searchedDocuments[indexPath.row]
        vc.configure(with: document)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let document = searchedDocuments[indexPath.row]
            documents.removeAll(where: { $0.uuid == document.uuid })
            searchedDocuments.remove(at: indexPath.row)
            DocumentStorageManager.shared.delete(with: document.uuid)
            documentsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

// MARK: - UISearchResultsUpdating

extension DocumentsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchedDocuments = documents.filter { document in
                guard let title = document.title else { return true }
                return title.lowercased().contains(searchText.lowercased())
            }
        } else {
            searchedDocuments = documents
        }
        documentsTableView.reloadData()
    }
}
