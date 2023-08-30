//
//  FormulaFactory.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 16.07.2023.
//

import UIKit

enum FormulaFactory {
    static func createFormulaView(for text: String) -> UIView {
        let scanner = LaTeXScanner(source: text)
        let tokens = scanner.scan()
        let parser = LaTeXParser(tokens: tokens)
        let expressions = parser.parse()
        return FormulaView(expressions: expressions)
    }
}
