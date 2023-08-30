//
//  LaTeXScanner.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 18.05.2023.
//

import Foundation

final class LaTeXScanner {
    let source: String
    
    private(set) var tokens: [Token] = []
    private var start: Int = 0
    private var current: Int = 0

    private var isEnd: Bool {
        current >= source.count
    }
    
    init(source: String) {
        self.source = source
    }
    
    func scan() -> [Token] {
        while !isEnd {
            start = current
            scanToken()
        }
        
        tokens.append(Token(type: .eof, lexeme: ""))
        return tokens
    }
}

private extension LaTeXScanner {
    func scanToken() {
        let char = advance()

        switch char {
        case "(":
            addToken(type: .leftParen)
        case ")":
            addToken(type: .rightParen)
        case "{":
            addToken(type: .leftBrace)
        case "}":
            addToken(type: .rightBrace)
        case "[":
            addToken(type: .leftBracket)
        case "]":
            addToken(type: .rightBracket)
        case ":":
            addToken(type: .colon)
        case ",":
            addToken(type: .comma)
        case ".":
            addToken(type: .dot)
        case "-":
            addToken(type: .minus)
        case "+":
            addToken(type: .plus)
        case ";":
            addToken(type: .semicolon)
        case "*":
            addToken(type: .star)
        case "^":
            addToken(type: .powerSign)
        case "!":
            addToken(type: match("=") ? .bangEqual : .bang)
        case "=":
            addToken(type: match("=") ? .equalEqual : .equal)
        case "<":
            addToken(type: match("=") ? .lessEqual : .less)
        case ">":
            addToken(type: match("=") ? .greaterEqual : .greater)
        case "/":
            addToken(type: .slash)
        case " ", "\r", "\t", "\n", "\"":
            break
        default:
            value()
        }
    }

    func addToken(type: TokenType) {
        let startIndex = source.index(source.startIndex, offsetBy: start)
        let endIndex = source.index(source.startIndex, offsetBy: current)
        let text = String(source[startIndex..<endIndex])
        let token = Token(type: type, lexeme: text)
        tokens.append(token)
    }

    func advance() -> Character {
        current += 1
        return source[source.index(source.startIndex, offsetBy: current - 1)]
    }

    func peek() -> Character {
        isEnd ? "\0" : source[source.index(source.startIndex, offsetBy: current)]
    }

    func peekNext() -> Character {
        current + 1 >= source.count
        ? "\0"
        : source[source.index(source.startIndex, offsetBy: current + 1)]
    }

    func match(_ expected: Character) -> Bool {
        if isEnd || peek() != expected { return false }
        current += 1
        return true
    }

    func isAlpha(_ c: Character) -> Bool {
        (c >= "a" && c <= "z") ||
        (c >= "A" && c <= "Z") ||
        c == "_"
    }

    func isAlphaNumeric(_ c: Character) -> Bool {
        isAlpha(c) || c.isNumber
    }

    func value() {
        while isAlphaNumeric(peek()) { _ = advance() }
        let startIndex = source.index(source.startIndex, offsetBy: start)
        let endIndex = source.index(source.startIndex, offsetBy: current)
        let text = String(source[startIndex..<endIndex])
        let type = Self.keywords[text] ?? .identifier
        addToken(type: type)
    }
}

extension LaTeXScanner {
    private static let keywords: [String: TokenType] = [
        "frac": .frac,
        "log": .fun,
        "sin": .fun,
        "cos": .fun,
        "tan": .fun,
        "cot": .fun,
        "sqrt": .fun,
        "sum": .sum,
        "prod": .prod,
    ]
}
