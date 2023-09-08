//
//  LaTeXPrinter.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 22.05.2023.
//

import Foundation

struct LaTeXASTPrinter {
    
    func getNodes(_ exprs: [Expression]) -> String {
        exprs.map { getNode($0) }.joined(separator: " ")
    }
    
    func getNode(_ expr: Expression) -> String {
        expr.accept(visitor: self)
    }
}

extension LaTeXASTPrinter: ExpressionVisitor {
    func visitVariableExpression(_ expr: VariableNode) -> String {
        "\(expr.token.lexeme)"
    }
    
    func visitBinaryExpression(_ expr: BinaryNode) -> String {
        let left = getNode(expr.left)
        let `operator` = expr.operator
        let right = getNode(expr.right)
        
        switch `operator`.type {
        case .slash:
            return "\\frac{\(left)}{\(right)}"
        case .star:
            return "\(left) \\cdot \(right)"
        case .lessEqual:
            return "\(left) \\leq \(right)"
        case .greaterEqual:
            return "\(left) \\geq \(right)"
        case .equalEqual:
            return "\(left) \\equiv \(right)"
        case .bangEqual:
            return "\(left) \\neq \(right)"
        default:
            return "\(left) \(`operator`.lexeme) \(right)"
        }
    }
    
    func visitPowerExpression(_ expr: PowerNode) -> String {
        "\(getNode(expr.value))^\(getNode(expr.power))"
    }
    
    func visitGroupingExpression(_ expr: GroupingNode) -> String {
        "\\left(\(getNode(expr.expression))\\right)"
    }
    
    func visitUnaryExpression(_ expr: UnaryNode) -> String {
        "\(expr.operator.lexeme)\(getNode(expr.right))"
    }
}

//let source = "2 + (3 - 4) * 5"
//let scanner = LaTeXScanner(source: source)
//let tokens = scanner.scan()
//let parser = LaTeXParser(tokens: tokens)
//if let expression = parser.parse() {
//    let printer = LaTeXASTPrinter()
//    let result = printer.print(expression)
//    print(result) // Output: (2 + ((3 - 4) * 5))
//} else {
//    print("Parsing error.")
//}
