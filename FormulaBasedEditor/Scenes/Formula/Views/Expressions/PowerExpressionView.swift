//
//  PowerExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 30.07.2023.
//

import UIKit

final class PowerExpressionView: UIView, ExpressionView {

    var level: CGFloat
    private var baseTerm: ExpressionView
    private var powerTerm: ExpressionView
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.spacing = 1
        return stack
    }()

    init(baseTerm: ExpressionView, powerTerm: ExpressionView) {
        self.baseTerm = baseTerm
        self.powerTerm = powerTerm
        self.level = baseTerm.level
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sizeForView() -> CGSize {
        let baseSize = baseTerm.sizeForView()
        let powerSize = powerTerm.sizeForView()
        let width = baseSize.width + powerSize.width
        let height = max(baseSize.height, powerSize.height + 15)
        return CGSize(width: width, height: height)
    }

    private func setupViews() {
        addSubview(hStack)
        hStack.addArrangedSubview(baseTerm)
        hStack.addArrangedSubview(powerTerm)

        let size = sizeForView()
        fixedWidth(size.width)
        fixedHeight(size.height)
        hStack
            .fitToSuperview()
        baseTerm
            .bottom()
        powerTerm
            .top()
    }
}

extension PowerExpressionView {
    private enum Constants {
        static let heightPadding: CGFloat = 4
        static let widthPadding: CGFloat = 3
    }
}
