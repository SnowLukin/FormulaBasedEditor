//
//  DocumentsCollectionView.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import UIKit

protocol DocumentsCollectionOutput: AnyObject {
    func onDocumentEdit(_ document: Document)
    func onDocumentDelete(_ document: Document)
}

final class DocumentsCollectionView: UICollectionView {
    
    weak var output: DocumentsCollectionOutput?
    
    var items: [Document] {
        snapshot.itemIdentifiers
    }
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Document> { (cell, indexPath, item) in
        let title = item.title ?? ""
        let dateString = item.wrappedLastEdit.formatedString()
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        contentConfiguration.secondaryText = dateString
        cell.contentConfiguration = contentConfiguration
        
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = title
        cell.accessibilityValue = "Открыть документ \(title)."
        cell.accessibilityHint = "Документ \(title). Последние изменения были: \(dateString)."
        cell.accessibilityTraits = .button
    }
    
    private var diffDataSource: UICollectionViewDiffableDataSource<Section, Document>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Document>()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        setupLayout()
        
        diffDataSource = UICollectionViewDiffableDataSource<Section, Document>(collectionView: self) { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration,
                                                                   for: indexPath,
                                                                   item: item)
            cell.accessories = [.disclosureIndicator()]
            return cell
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with documents: [Document], animated: Bool = false) {
        snapshot = NSDiffableDataSourceSnapshot<Section, Document>()
        snapshot.appendSections([.main])
        snapshot.appendItems(documents, toSection: .main)

        diffDataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func item(for indexPath: IndexPath) -> Document? {
        diffDataSource.itemIdentifier(for: indexPath)
    }
    
    private func setupLayout() {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in
            
            guard let item = diffDataSource.itemIdentifier(for: indexPath) else {
                return nil
            }
            
            let editAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                self.output?.onDocumentEdit(item)
                completion(true)
            }
            editAction.image = UIImage(systemName: "pencil.line")
            editAction.backgroundColor = .systemOrange
            
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
                self.output?.onDocumentDelete(item)
                self.snapshot.deleteItems([item])
                self.diffDataSource.apply(self.snapshot, animatingDifferences: true)
                completion(true)
            }
            
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemPink
            
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        collectionViewLayout = layout
    }
}

extension DocumentsCollectionView {
    private enum Section {
        case main
    }
}
