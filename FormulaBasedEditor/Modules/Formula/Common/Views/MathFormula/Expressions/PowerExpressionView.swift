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
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
        let height = baseSize.height + powerSize.height * Constants.powerHeightMultiplier
        return CGSize(width: width, height: height)
    }

    private func setupViews() {
        addSubviews(container)
        container.addSubviews(baseTerm, powerTerm)

        let size = sizeForView()
        fixedWidth(size.width)
        fixedHeight(size.height)
        container
            .fixedWidth(size.width)
            .fixedHeight(size.height)
            .centerVertically()
            .centerHorizontally()
        baseTerm
            .leading()
            .bottom()
            .top()
        powerTerm
            .top()
            .leading(2, to: baseTerm.trailingAnchor)
    }
}

extension PowerExpressionView {
    private enum Constants {
        static let heightPadding: CGFloat = 4
        static let widthPadding: CGFloat = 3
        static let powerHeightMultiplier: CGFloat = 2
    }
}
