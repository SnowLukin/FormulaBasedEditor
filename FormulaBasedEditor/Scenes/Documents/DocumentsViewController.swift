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

    private var documents: [Document] = []

    private let documentsTableView = UITableView(frame: .zero, style: .insetGrouped)

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
    
    // MARK: Setup
    
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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Документы"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: Public

    func fetchDocuments() {
        let documents = DocumentStorageManager.shared.fetchDocuments()
        self.documents = documents.sorted(by: { $0.wrappedLastEdit < $1.wrappedLastEdit })
    }

    // MARK: Private

    private func setupViews() {
        view.addSubviews(documentsTableView, emptyListLabel, bottomBar)
        bottomBar.addSubview(addDocumentButton)
        updateView()
        setupTableView()
        setupAddDocumentButton()

        documentsTableView
            .fitToSuperview()
        bottomBar
            .fixedHeight(60)
            .leadingAndTrailing()
            .safeAreaBottom()
        addDocumentButton
            .fixedHeight(40)
            .fixedWidth(40)
            .trailing(20)
            .centerVertically()
        emptyListLabel
            .centerVertically()
            .centerHorizontally()
    }

    private func setupTableView() {
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        documentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "documentsTableViewCell")
    }

    private func setupAddDocumentButton() {
        addDocumentButton.addTarget(self, action: #selector(addDocumentButtonTapped), for: .touchUpInside)
    }

    private func updateView() {
        fetchDocuments()
        emptyListLabel.isHidden = !documents.isEmpty
        documentsTableView.isScrollEnabled = !documents.isEmpty
        documentsTableView.reloadData()
    }

    @objc func addDocumentButtonTapped() {
        let alertController = UIAlertController(
            title: "Новый документ",
            message: "Введите название документа",
            preferredStyle: .alert
        )
        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Создать", style: .default) { [unowned alertController] _ in
            let answer = alertController.textFields![0]
            guard let title = answer.text else { return }
            let params = Document.Parameters(title: title, text: nil)
            DocumentStorageManager.shared.createDocument(with: params)
            self.updateView()
        }

        alertController.addAction(submitAction)

        present(alertController, animated: true)
    }
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        documents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentsTableViewCell", for: indexPath)
        let document = documents[indexPath.row]
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = document.text?.string
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrentDocumentViewController()
        let document = documents[indexPath.row]
        vc.configure(with: document)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}
