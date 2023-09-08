//
//  BinaryExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 30.07.2023.
//

import UIKit

final class BinaryExpressionView: UIView, ExpressionView {

    var level: CGFloat
    
    private var binaryOperator: String

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
        stack.distribution = .fillProportionally
        stack.spacing = Constants.spacing
        return stack
    }()

    init(leftTerm: ExpressionView, rightTerm: ExpressionView, binaryOperator: String) {
        self.binaryOperator = binaryOperator
        self.leftTerm = leftTerm
        self.rightTerm = rightTerm
        self.level = max(leftTerm.level, rightTerm.level)
        self.binaryOperatorTerm = BaseExpresionView(text: binaryOperator, level: level)
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
        let width = leftTermSize.width + operatorSize.width + rightTermSize.width + Constants.spacing * 4
        let height = max(leftTermSize.height, rightTermSize.height, operatorSize.height)
        return CGSize(width: width, height: height)
    }

    private func setupViews() {
        addSubview(hStack)
        hStack.addArrangedSubview(leftTerm)
        if binaryOperator == Constants.multOperator {
            hStack.addArrangedSubview(multOperator)
            multOperator
                .fixedHeight(binaryOperatorTerm.sizeForView().height / 1.5)
                .fixedWidth(binaryOperatorTerm.sizeForView().width)
        } else {
            hStack.addArrangedSubview(binaryOperatorTerm)
        }
        hStack.addArrangedSubview(rightTerm)

        let size = sizeForView()
        fixedHeight(size.height)
        fixedWidth(size.width)
        hStack
            .fixedHeight(size.height)
            .fixedWidth(size.width)
            .centerVertically()
            .centerHorizontally()
    }
    
    private func setupMult() {
        let container = UIView()
        addSubviews(leftTerm, container, rightTerm)
        container.addSubview(multOperator)
        
        leftTerm
            .leading()
            .centerHorizontally()
        container
            .fixedWidth(binaryOperatorTerm.sizeForView().width)
            .fixedHeight(binaryOperatorTerm.sizeForView().height)
            .leading(5, to: leftTerm)
        rightTerm
            .leading(5, to: container)
            .centerHorizontally()
        multOperator
            .equalHeight(1/1.5, with: container)
            .fixedWidth(binaryOperatorTerm.sizeForView().width)
            .centerHorizontally()
            .centerVertically()
    }
    
    private func setupBinary() {
        addSubviews(leftTerm, binaryOperatorTerm, rightTerm)
        leftTerm
            .centerHorizontally()
            .fixedWidth(leftTerm.sizeForView().width)
            .leading()
        binaryOperatorTerm
            .fixedWidth(11)
            .leading(5, to: leftTerm.trailingAnchor)
            .centerHorizontally()
        rightTerm
            .top()
            .bottom()
            .leading(5, to: binaryOperatorTerm.trailingAnchor)
            .trailing()
            .centerHorizontally()
    }
}

extension BinaryExpressionView {
    private enum Constants {
        static let multOperator = "*"
        static let spacing: CGFloat = 2
    }
}
