//
//  DocumentStorageManager.swift
//  FormulaBasedEditor
//
//  Created by Denis Mandych on 27.08.2023.
//

import UIKit
import CoreData

final class DocumentStorageManager {
    static let shared = DocumentStorageManager()
    private init() {}

    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }

    func createDocument(with parameters: Document.Parameters) {
        guard let documentEntity = NSEntityDescription.entity(
            forEntityName: Constants.documentEntityName,
            in: context
        ) else {
            assertionFailure("Failed saving document")
            return
        }
        let document = Document(entity: documentEntity, insertInto: context)
        document.uuid = UUID()
        document.title = parameters.title
        document.text = parameters.text
        document.lastEdit = parameters.lastEdit

        appDelegate.saveContext()
    }

    func fetchDocuments() -> [Document] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.documentEntityName)
        do {
            return try context.fetch(fetchRequest) as! [Document]
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return []
    }

    func fetchDocument(with uuid: UUID) -> Document? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.documentEntityName)
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        do {
            let documents = try? context.fetch(fetchRequest) as? [Document]
            return documents?.first
        }
    }

    func updateDocument(
        uuid: UUID,
        with parameters: Document.Parameters
    ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.documentEntityName)
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
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

    func deleteDocument(with uuid: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.documentEntityName)
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        do {
            guard let documents = try? context.fetch(fetchRequest) as? [Document],
                  let document = documents.first
            else { return }
            context.delete(document)
        }
        appDelegate.saveContext()
    }
}

// MARK: Formula Manager

extension DocumentStorageManager {
    private func addFormula(to document: Document, from params: LatexFormula.Parameters) {
        guard let formulaEntity = NSEntityDescription.entity(
            forEntityName: Constants.formulaEntityName,
            in: context
        ) else {
            assertionFailure("Failed saving document")
            return
        }
        let formula = LatexFormula(entity: formulaEntity, insertInto: context)
        formula.uuid = UUID()
        formula.content = params.content
        formula.document = document
        document.addToFormulas(formula)
    }
}

// MARK: Constants

extension DocumentStorageManager {
    private enum Constants {
        static let documentEntityName = "Document"
        static let formulaEntityName = "LatexFormula"
    }
}
