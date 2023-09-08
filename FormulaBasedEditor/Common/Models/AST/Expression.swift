//
//  Expression.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 17.05.2023.
//

import Foundation

protocol ExpressionVisitor {
    associatedtype ExpressionReturnType
    
    func visitVariableExpression(_ expr: VariableNode) -> ExpressionReturnType
    func visitBinaryExpression(_ expr: BinaryNode) -> ExpressionReturnType
    func visitPowerExpression(_ expr: PowerNode) -> ExpressionReturnType
    func visitGroupingExpression(_ expr: GroupingNode) -> ExpressionReturnType
    func visitUnaryExpression(_ expr: UnaryNode) -> ExpressionReturnType
}

protocol Expression {
    func accept<T: ExpressionVisitor>(visitor: T) -> T.ExpressionReturnType
}

protocol Levelable {
    var level: CGFloat { get set }
}

struct VariableNode: Expression, Levelable {
    let token: Token
    var level: CGFloat
    
    func accept<T>(visitor: T) -> T.ExpressionReturnType where T : ExpressionVisitor {
        visitor.visitVariableExpression(self)
    }
}

struct BinaryNode: Expression, Levelable {
    let left: Expression
    let `operator`: Token
    let right: Expression
    var level: CGFloat
    
    func accept<T>(visitor: T) -> T.ExpressionReturnType where T : ExpressionVisitor {
        visitor.visitBinaryExpression(self)
    }
}

struct PowerNode: Expression, Levelable {
    let value: Expression
    let power: Expression
    var level: CGFloat
    
    func accept<T>(visitor: T) -> T.ExpressionReturnType where T : ExpressionVisitor {
        visitor.visitPowerExpression(self)
    }
}

struct GroupingNode: Expression, Levelable {
    let expression: Expression
    var level: CGFloat
    
    func accept<T>(visitor: T) -> T.ExpressionReturnType where T : ExpressionVisitor {
        visitor.visitGroupingExpression(self)
    }
}

struct UnaryNode: Expression, Levelable {
    let `operator`: Token
    let right: Expression
    var level: CGFloat
    
    func accept<T>(visitor: T) -> T.ExpressionReturnType where T : ExpressionVisitor {
        visitor.visitUnaryExpression(self)
    }
}
