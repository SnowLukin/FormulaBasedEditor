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

    @NSManaged public var uuid: String
    @NSManaged public var title: String?
    @NSManaged public var text: NSAttributedString?
    @NSManaged public var lastEdit: Date?

    public var wrappedLastEdit: Date {
        lastEdit ?? Date()
    }
}

extension Document : Identifiable {

}

extension Document {
    struct Parameters {
        let title: String
        let text: NSAttributedString?
        let lastEdit: Date

        init(
            title: String,
            text: NSAttributedString? = nil,
            lastEdit: Date = Date()
        ) {
            self.title = title
            self.text = text
            self.lastEdit = lastEdit
        }
    }
}
