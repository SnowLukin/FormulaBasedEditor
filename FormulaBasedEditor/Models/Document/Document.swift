//
//  Document+CoreDataProperties.swift
//  FormulaBasedEditor
//
//  Created by Denis Mandych on 27.08.2023.
//
//

import Foundation
import CoreData

@objc(Document)
public class Document: NSManagedObject {

}

extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var title: String?
    @NSManaged public var text: NSAttributedString?
    @NSManaged public var lastEdit: Date?
    @NSManaged public var formulas: NSSet?

    public var wrappedLastEdit: Date {
        lastEdit ?? Date()
    }

    public var wrappedFormulas: [LatexFormula] {
        guard let formulas = formulas else { return [] }
        return formulas.compactMap { $0 as? LatexFormula }
    }
}

// MARK: Generated accessors for formulas

extension Document {

    @objc(addFormulasObject:)
    @NSManaged public func addToFormulas(_ value: LatexFormula)

    @objc(removeFormulasObject:)
    @NSManaged public func removeFromFormulas(_ value: LatexFormula)

    @objc(addFormulas:)
    @NSManaged public func addToFormulas(_ values: NSSet)

    @objc(removeFormulas:)
    @NSManaged public func removeFromFormulas(_ values: NSSet)

}

extension Document : Identifiable {

}

extension Document {
    struct Parameters {
        let title: String
        let text: NSAttributedString?
        let lastEdit: Date
        let formulas: [LatexFormula.Parameters]

        init(
            title: String,
            text: NSAttributedString? = nil,
            lastEdit: Date = Date(),
            formulas: [LatexFormula.Parameters] = []
        ) {
            self.title = title
            self.text = text
            self.lastEdit = lastEdit
            self.formulas = formulas
        }
    }
}
