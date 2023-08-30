//
//  Formula+CoreDataProperties.swift
//  FormulaBasedEditor
//
//  Created by Denis Mandych on 27.08.2023.
//
//

import Foundation
import CoreData

@objc(LatexFormula)
public class LatexFormula: NSManagedObject {

}

extension LatexFormula {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LatexFormula> {
        return NSFetchRequest<LatexFormula>(entityName: "LatexFormula")
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var content: String?
    @NSManaged public var document: Document?

    public var wrappedContent: String {
        content ?? ""
    }
}

extension LatexFormula : Identifiable {

}

extension LatexFormula {
    struct Parameters {
        let content: String
        let document: Document?

        init(content: String?, document: Document? = nil) {
            self.content = content ?? ""
            self.document = document
        }
    }
}
