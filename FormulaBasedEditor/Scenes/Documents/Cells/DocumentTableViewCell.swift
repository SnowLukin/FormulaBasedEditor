//
//  DocumentTableViewCell.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.09.2023.
//

import UIKit

final class DocumentTableViewCell: UITableViewCell {
    static let reuseIdentifier = "documentsTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, subtitle: String) {
        self.textLabel?.text = title
        self.detailTextLabel?.text = subtitle
        self.detailTextLabel?.textColor = .gray
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityValue = "Открыть документ \(title)."
        self.accessibilityHint = "Нажмите, чтобы открыть документ \(title). Последние изменения были: \(subtitle)."
        self.accessibilityTraits = .button
    }
}
