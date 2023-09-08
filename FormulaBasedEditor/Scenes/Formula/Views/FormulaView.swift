//
//  FormulaView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 07.08.2023.
//

import UIKit

protocol FormulaViewProtocol: UIView {
    var uuid: String { get }
    var content: String { get }
}

final class FormulaView: UIView, FormulaViewProtocol {
    
    var uuid: String
    var content: String

    private var expressionViews: [ExpressionView] = []

    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()

    init(content: String, expressions: [Expression], uuid: String = UUID().uuidString) {
        self.uuid = uuid
        self.content = content
        super.init(frame: .zero)
        buildExpressionViews(from: expressions)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func sizeForView() -> CGSize {
        var size = CGSize()
        expressionViews.forEach { size.addWithHeightLimit($0.sizeForView()) }
        return CGSize(width: size.width, height: size.height)
    }

    private func setupViews() {
        addSubview(hStack)
        expressionViews.forEach { hStack.addArrangedSubview($0) }
        
        let size = sizeForView()
        frame.size = CGSize(
            width: size.width + Constants.hPadding,
            height: size.height + Constants.vPadding
        )
        
        hStack
            .fixedWidth(size.width)
            .fixedHeight(size.height)
            .centerVertically()
            .centerHorizontally()
    }

    private func buildExpressionViews(from expressions: [Expression]) {
        let factory = FormulaExpressionBuilder()
        expressionViews = factory.makeExpressionViews(from: expressions)
    }
}

private extension FormulaView {
    enum Constants {
        static let hPadding: CGFloat = 10
        static let vPadding: CGFloat = 4
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

    func visitBinaryExpression(_ expr: BinaryNode) -> ExpressionView {
        let leftTerm = expr.left.accept(visitor: self)
        let rightTerm = expr.right.accept(visitor: self)

        if expr.operator.type == .slash {
            return FractionExpressionView(nominator: leftTerm, dominator: rightTerm)
        }
        return BinaryExpressionView(
            leftTerm: leftTerm,
            rightTerm: rightTerm,
            binaryOperator: expr.operator.lexeme
        )
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
