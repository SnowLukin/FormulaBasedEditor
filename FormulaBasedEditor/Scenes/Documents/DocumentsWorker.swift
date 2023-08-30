//
//  DocumentsWorker.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 28.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit
import CoreData

class DocumentsWorker {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveDocument(document: Documents.Entity) {
        let entity = NSEntityDescription.entity(forEntityName: "Document", in: context)
        let newDocument = NSManagedObject(entity: entity!, insertInto: context)
        newDocument.setValue(document.title, forKey: "title")
        newDocument.setValue(document.date, forKey: "date")
        newDocument.setValue(document.text, forKey: "text")
        
        do {
            try context.save()
        } catch {
            print("CoreDataWorker: Failed to save document")
        }
    }
    
    func fetchDocuments() -> [Documents.Entity] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Document")
        var documentEntities: [Documents.Entity] = []
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let title = data.value(forKey: "title") as? String
                let date = data.value(forKey: "date") as? Date
                let textData = data.value(forKey: "text") as? Data
                guard let title, let date, let textData else { return documentEntities }
                if let decodedAttributedString = try? NSKeyedUnarchiver
                    .unarchiveTopLevelObjectWithData(textData) as? NSMutableAttributedString
                {
                    let restoredAttributedString = restoreImagesInAttributedString(
                        decodedAttributedString: decodedAttributedString
                    )
                    let documentEntity = Documents.Entity(
                        title: title,
                        date: date,
                        attributedString: restoredAttributedString,
                        text: textData
                    )
                    documentEntities.append(documentEntity)
                }
            }
        } catch {
            print("DocumentWorker: Failed to fetch documents")
        }
        return documentEntities
    }
    
    func saveImagesInAttributedString(attributedString: NSAttributedString) -> NSMutableAttributedString {
        let newAttributedString = NSMutableAttributedString(attributedString: attributedString)
        newAttributedString.enumerateAttribute(
            .attachment,
            in: NSRange(location: 0, length: newAttributedString.length),
            options: []
        ) { value, range, stop in
            if let attachment = value as? NSTextAttachment,
               let image = attachment.image {
                let uuid = UUID().uuidString
                let imagePath = getDocumentsDirectory().appendingPathComponent("\(uuid).png")
                if let imageData = image.pngData() {
                    try? imageData.write(to: imagePath)
                    let placeholder = NSAttributedString(string: "{image:\(uuid)}")
                    newAttributedString.replaceCharacters(in: range, with: placeholder)
                }
            }
        }
        return newAttributedString
    }
}

private extension DocumentsWorker {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func restoreImagesInAttributedString(
        decodedAttributedString: NSMutableAttributedString
    ) -> NSMutableAttributedString {
        let restoredAttributedString = decodedAttributedString
        let regex = try! NSRegularExpression(pattern: "\\{image:([a-z0-9-]+)\\}", options: .caseInsensitive)
        let matches = regex.matches(
            in: restoredAttributedString.string,
            options: [],
            range: NSRange(location: 0, length: restoredAttributedString.length)
        )
        for match in matches.reversed() {
            let uuid = (restoredAttributedString.string as NSString).substring(with: match.range(at: 1))
            let imagePath = getDocumentsDirectory().appendingPathComponent("\(uuid).png")
            if let imageData = try? Data(contentsOf: imagePath),
               let image = UIImage(data: imageData) {
                let textAttachment = NSTextAttachment()
                textAttachment.image = image
                let replacement = NSAttributedString(attachment: textAttachment)
                restoredAttributedString.replaceCharacters(in: match.range, with: replacement)
            }
        }
        return restoredAttributedString
    }
}
