//
//  TokenType.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 17.05.2023.
//

import Foundation

enum TokenType {
    // Single-character tokens.
    case leftParen, rightParen, leftBrace, rightBrace, leftBracket, rightBracket
    case comma, dot, minus, plus, semicolon, slash, star, colon, powerSign
    
    // One or two character tokens.
    case bang, bangEqual
    case equal, equalEqual
    case greater, greaterEqual
    case less, lessEqual
    
    // Literals.
    case identifier, string, number
    
    // Keywords.
    case fun    // log, cos, sin, tan, cot, sqrt
    case sum, prod, frac
    
    // End of file.
    case eof
}
