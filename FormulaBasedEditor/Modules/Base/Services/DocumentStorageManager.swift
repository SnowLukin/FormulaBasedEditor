//
//  DocumentStorageManager.swift
//  FormulaBasedEditor
//
//  Created by Denis Mandych on 27.08.2023.
//

import UIKit
import CoreData

protocol StorageManager {
    associatedtype ParameterType
    
    func create(with params: ParameterType)
    func fetchAll()
    func fetch(by id: UUID)
    func update(_ id: UUID, with params: ParameterType)
    func delete(_ id: UUID)
}

final class DocumentStorageManager {
    static let shared = DocumentStorageManager()
    private init() {}

    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }

    func create(with parameters: Document.Parameters) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: Constants.entityName,
            in: context
        ) else {
            assertionFailure("Failed saving document")
            return
        }
        let document = Document(entity: entity, insertInto: context)
        document.uuid = UUID().uuidString
        document.title = parameters.title
        document.text = parameters.text
        document.lastEdit = parameters.lastEdit

        appDelegate.saveContext()
    }

    func fetchDocuments() -> [Document] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        do {
            return try context.fetch(fetchRequest) as! [Document]
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return []
    }

    func fetch(with uuid: String) -> Document? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        do {
            let documents = try? context.fetch(fetchRequest) as? [Document]
            return documents?.first
        }
    }

    func update(
        uuid: String,
        with parameters: Document.Parameters
    ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        do {
            let documents = try context.fetch(fetchRequest) as! [Document]
            guard let document = documents.first else { return }

            document.title = parameters.title
            document.text = parameters.text
            document.lastEdit = parameters.lastEdit
        } catch {
            print(error.localizedDescription)
        }
        appDelegate.saveContext()
    }

    func delete(with uuid: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        do {
            guard let documents = try? context.fetch(fetchRequest) as? [Document],
                  let document = documents.first
            else { return }
            context.delete(document)
        }
        appDelegate.saveContext()
    }
}

// MARK: Constants

extension DocumentStorageManager {
    private enum Constants {
        static let entityName = "Document"
    }
}
