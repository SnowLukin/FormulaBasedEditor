//
//  FractionExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 29.07.2023.
//

import UIKit

final class FractionExpressionView: UIView, ExpressionView {

    var level: CGFloat
    private var nominator: ExpressionView
    private var dominator: ExpressionView

    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .bottom
        stack.spacing = Constants.vPadding
        return stack
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    init(nominator: ExpressionView, dominator: ExpressionView) {
        self.nominator = nominator
        self.dominator = dominator
        self.level = nominator.level
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sizeForView() -> CGSize {
        let nominatorSize = nominator.sizeForView()
        let dominatorSize = dominator.sizeForView()
        let width = max(nominatorSize.width, dominatorSize.width)
        let height = nominatorSize.height + dominatorSize.height + Constants.lineHeight + Constants.vPadding * 2
        return CGSize(width: width, height: height)
    }

    private func setupViews() {
        addSubview(vStack)
        vStack.addArrangedSubviews(nominator, lineView, dominator)

        let size = sizeForView()
        fixedWidth(size.width + Constants.hPadding)
        fixedHeight(size.height + Constants.vPadding)

        vStack
            .fixedWidth(size.width)
            .fixedHeight(size.height)
            .centerHorizontally()
            .centerVertically()
        nominator
            .centerHorizontally()
        lineView
            .equalWidth(with: vStack)
            .centerHorizontally()
            .fixedHeight(Constants.lineHeight)
        dominator
            .centerHorizontally()
    }
}

private extension FractionExpressionView {
    enum Constants {
        static let lineHeight: CGFloat = 1
        static let hPadding: CGFloat = 4
        static let vPadding: CGFloat = 4
    }
}
