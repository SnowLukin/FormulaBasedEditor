//
//  Parser.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 18.05.2023.
//

import Foundation

final class LaTeXParser {
    private let tokens: [Token]
    private var current = 0

    private var isEnd: Bool {
        peek.type == .eof
    }

    private var peek: Token {
        tokens[current]
    }

    private var previous: Token {
        tokens[current - 1]
    }
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    func parse() -> [Expression] {
        var expressions: [Expression] = []
        while !isEnd {
            expressions.append(equality())
        }
        return expressions
    }
}

private extension LaTeXParser {
    func equality(level: CGFloat = 0) -> Expression {
        var expr = comparison(level: level)

        while match(types: [.bangEqual, .equalEqual]) {
            let `operator` = previous
            let right = comparison(level: level)
            expr = BinaryNode(left: expr, operator: `operator`, right: right, level: level)
        }

        return expr
    }

    func comparison(level: CGFloat) -> Expression {
        var expr = term(level: level)

        while match(types: [.greater, .greaterEqual, .less, .lessEqual]) {
            let `operator` = previous
            let right = term(level: level)
            expr = BinaryNode(left: expr, operator: `operator`, right: right, level: level)
        }

        return expr
    }

    func term(level: CGFloat) -> Expression {
        var expr = factor(level: level)

        while match(types: [.minus, .plus]) {
            let `operator` = previous
            let right = factor(level: level)
            expr = BinaryNode(left: expr, operator: `operator`, right: right, level: level)
        }

        return expr
    }

    func factor(level: CGFloat) -> Expression {
        var expr = power(level: level)

        while match(types: [.slash, .star]) {
            let `operator` = previous
            let right = power(level: level)
            expr = BinaryNode(left: expr, operator: `operator`, right: right, level: level)
        }

        return expr
    }

    func power(level: CGFloat) -> Expression {
        var expr = unary(level: level)

        while match(types: [.powerSign]) {
            let power = equality(level: level + 1)
            expr = PowerNode(value: expr, power: power, level: level)
        }

        return expr
    }

    func unary(level: CGFloat) -> Expression {
        if match(types: [.bang, .minus]) {
            let `operator` = previous
            let right = unary(level: level)
            return UnaryNode(operator: `operator`, right: right, level: level)
        }

        return call(level: level)
    }

    func call(level: CGFloat) -> Expression {
        var expr = primary(level: level)

        while true {
            if match(types: [.leftParen]) {
                expr = finishCall(callee: expr, level: level + 1)
            } else {
                break
            }
        }

        return expr
    }

    func finishCall(callee: Expression, level: CGFloat) -> Expression {
        var arguments: [Expression] = []

        if !check(type: .rightParen) {
            repeat {
                arguments.append(equality(level: level + 1))
            } while match(types: [.comma])
        }

        if !check(type: .rightParen) {
            print("Expect ')' after arguments.")
            _ = advance()
            return CallNode(callee: callee, arguments: arguments, level: level)
        }

        _ = advance()
        return CallNode(callee: callee, arguments: arguments, level: level)
    }

    func primary(level: CGFloat) -> Expression {
        if match(types: [.number]) {
            print("Here")
            return VariableNode(token: previous, level: level)
        }

        if match(types: [.identifier]) {
            return VariableNode(token: previous, level: level)
        }

        if match(types: [.leftParen]) {
            let expr = equality(level: level)
            if !match(types: [.rightParen]) {
                print("Expect ')' after arguments.")
                return GroupingNode(expression: expr, level: level)
            }
            return GroupingNode(expression: expr, level: level)
        }

        print("Expect expression.")
        let token = advance()
        print(token)
        return VariableNode(token: token, level: level)
    }

    func match(types: [TokenType]) -> Bool {
        for type in types {
            if check(type: type) {
                _ = advance()
                return true
            }
        }
        return false
    }

    func check(type: TokenType) -> Bool {
        isEnd ? false : peek.type == type
    }

    func advance() -> Token {
        if !isEnd { current += 1 }
        return previous
    }
}
