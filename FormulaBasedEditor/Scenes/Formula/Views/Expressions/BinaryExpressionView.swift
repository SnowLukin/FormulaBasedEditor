//
//  BinaryExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 30.07.2023.
//

import UIKit

final class BinaryExpressionView: UIView, ExpressionView {

    var level: CGFloat
    private var binaryOperator: Operator

    private var leftTerm: ExpressionView
    private var rightTerm: ExpressionView
    private var binaryOperatorTerm: BaseExpresionView
    private let multOperator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "multIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Constants.spacing
        return stack
    }()

    init(leftTerm: ExpressionView, rightTerm: ExpressionView, binaryOperator: Operator) {
        self.leftTerm = leftTerm
        self.binaryOperator = binaryOperator
        self.rightTerm = rightTerm
        self.level = max(leftTerm.level, rightTerm.level)
        self.binaryOperatorTerm = BaseExpresionView(text: binaryOperator.rawValue, level: level)
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sizeForView() -> CGSize {
        let leftTermSize = leftTerm.sizeForView()
        let rightTermSize = rightTerm.sizeForView()
        let operatorSize = binaryOperatorTerm.sizeForView()
        let width = leftTermSize.width + operatorSize.width + rightTermSize.width + 2 * Constants.spacing
        let height = max(leftTermSize.height, rightTermSize.height, operatorSize.height)
        return CGSize(width: width, height: height)
    }

    private func setupViews() {
        addSubview(hStack)
        hStack.addArrangedSubview(leftTerm)
        if binaryOperator == .mult {
            let container = UIView()
            container.addSubview(multOperator)
            hStack.addArrangedSubview(container)
            container
                .fixedWidth(binaryOperatorTerm.sizeForView().width)
                .fixedHeight(binaryOperatorTerm.sizeForView().height)
                .centerVertically()
            multOperator
                .equalHeight(1/1.5, with: container)
                .fixedWidth(binaryOperatorTerm.sizeForView().width)
                .centerHorizontally()
                .centerVertically()
        } else {
            hStack.addArrangedSubview(binaryOperatorTerm)
        }
        hStack.addArrangedSubview(rightTerm)

        let size = sizeForView()
        fixedHeight(size.height)
        fixedWidth(size.width)
        hStack
            .fitToSuperview()
    }
}

extension BinaryExpressionView {
    enum Operator: String {
        case plus = "+"
        case minus = "-"
        case mult = "*"
    }

    private enum Constants {
        static let spacing: CGFloat = 1
    }
}
