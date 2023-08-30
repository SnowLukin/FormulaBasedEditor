//
//  FractionExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 29.07.2023.
//

import UIKit

final class FractionExpressionView: UIView, ExpressionView {

    private var nominator: ExpressionView
    private var dominator: ExpressionView
    var level: CGFloat

    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .bottom
        return stack
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        let width = sizeForView().width
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
        let height = nominatorSize.height + dominatorSize.height + Constants.lineHeight
        return CGSize(width: width, height: height)
    }

    private func setupViews() {
        addSubview(vStack)
        vStack.addArrangedSubview(nominator)
        vStack.addArrangedSubview(lineView)
        vStack.addArrangedSubview(dominator)

        let size = sizeForView()
        fixedWidth(size.width)
        fixedHeight(size.height)

        vStack
            .fitToSuperview()
        lineView
            .centerHorizontally()
            .equalWidth(with: self)
            .fixedHeight(Constants.lineHeight)
        nominator
            .centerHorizontally()
        dominator
            .centerHorizontally()
    }
}

private extension FractionExpressionView {
    enum Constants {
        static let lineHeight: CGFloat = 1
    }
}
