//
//  GroupingExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 03.08.2023.
//

import UIKit

class GroupingExpressionView: UIView, ExpressionView {

    var level: CGFloat
    private var expressionView: ExpressionView
    private var leftBrace: BraceExpressionView
    private var rightBrace: BraceExpressionView

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        return stack
    }()

    init(expressionView: ExpressionView, level: CGFloat) {
        self.expressionView = expressionView
        let height = expressionView.sizeForView().height
        self.leftBrace = BraceExpressionView(
            side: .left,
            height: height,
            level: expressionView.level
        )
        self.rightBrace = BraceExpressionView(
            side: .right,
            height: height,
            level: expressionView.level
        )
        self.level = level
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sizeForView() -> CGSize {
        let expressionSize = expressionView.sizeForView()
        let leftBraceSize = leftBrace.sizeForView()
        let rightBraceSize = rightBrace.sizeForView()
        let width = leftBraceSize.width + expressionSize.width + rightBraceSize.width
        let height = max(leftBraceSize.height, expressionSize.height, rightBraceSize.height)
        return CGSize(width: width, height: height)
    }

    private func setupViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(leftBrace)
        stackView.addArrangedSubview(expressionView)
        stackView.addArrangedSubview(rightBrace)

        stackView
            .fitToSuperview()
    }
}
