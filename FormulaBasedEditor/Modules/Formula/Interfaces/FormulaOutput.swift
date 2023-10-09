//
//  FormulaOutput.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 09.10.2023.
//

import Foundation

protocol FormulaOutput: AnyObject {
    func addAttachment(_ formula: MathFormula, at range: NSRange?)
}
