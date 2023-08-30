//
//  FormulaView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 07.08.2023.
//

import UIKit

final class FormulaView: UIView {

    private var expressionViews: [ExpressionView] = []

    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()

    init(expressions: [Expression]) {
        super.init(frame: .zero)
        buildExpressionViews(from: expressions)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func sizeForView() -> CGSize {
        var size = CGSize(width: Constants.widthPadding, height: Constants.heightPadding)
        expressionViews.forEach { size.addWithHeightLimit($0.sizeForView()) }
        return CGSize(width: size.width, height: size.height)
    }

    private func setupViews() {
        frame.size = sizeForView()
        addSubview(hStack)
        expressionViews.forEach { hStack.addArrangedSubview($0) }
        hStack
            .fitToSuperview()
    }

    private func buildExpressionViews(from expressions: [Expression]) {
        let factory = FormulaExpressionBuilder()
        expressionViews = factory.makeExpressionViews(from: expressions)
    }
}

private extension FormulaView {
    enum Constants {
        static let widthPadding: CGFloat = 4
        static let heightPadding: CGFloat = 0
    }
}

private final class FormulaExpressionBuilder: ExpressionVisitor {

    func makeExpressionViews(from expressions: [Expression]) -> [ExpressionView] {
        expressions.map { $0.accept(visitor: self) }
    }

    typealias ExpressionReturnType = ExpressionView

    func visitVariableExpression(_ expr: VariableNode) -> ExpressionView {
        BaseExpresionView(text: expr.token.lexeme, level: CGFloat(expr.level))
    }

    func visitCallExpression(_ expr: CallNode) -> ExpressionView {
        let callee = expr.callee.accept(visitor: self)
        let arguments = expr.arguments.map { $0.accept(visitor: self) }
//        return FunctionView(callee: callee, arguments: arguments)
        return BaseExpresionView(text: "Nope", level: 0)
    }

    func visitBinaryExpression(_ expr: BinaryNode) -> ExpressionView {
        let leftTerm = expr.left.accept(visitor: self)
        let rightTerm = expr.right.accept(visitor: self)

        if expr.operator.type == .slash {
            return FractionExpressionView(nominator: leftTerm, dominator: rightTerm)
        } else {
            let binaryOperator: BinaryExpressionView.Operator
            switch expr.operator.type {
            case .star: binaryOperator = .mult
            case .plus: binaryOperator = .plus
            default: binaryOperator = .minus
            }
            return BinaryExpressionView(
                leftTerm: leftTerm,
                rightTerm: rightTerm,
                binaryOperator: binaryOperator
            )
        }
    }

    func visitPowerExpression(_ expr: PowerNode) -> ExpressionView {
        let base = expr.value.accept(visitor: self)
        let power = expr.power.accept(visitor: self)
        return PowerExpressionView(baseTerm: base, powerTerm: power)
    }

    func visitGroupingExpression(_ expr: GroupingNode) -> ExpressionView {
        let expressionView = expr.expression.accept(visitor: self)
        return GroupingExpressionView(expressionView: expressionView, level: CGFloat(expr.level))
    }

    func visitUnaryExpression(_ expr: UnaryNode) -> ExpressionView {
        expr.right.accept(visitor: self)
    }
}
