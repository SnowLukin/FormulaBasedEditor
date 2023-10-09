//
//  BaseExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 29.07.2023.
//

import UIKit

final class BaseExpresionView: UILabel, ExpressionView {

    var level: CGFloat

    init(text: String, level: CGFloat) {
        self.level = level
        super.init(frame: .zero)
        setupLabel(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sizeForView() -> CGSize {
        let text = self.text ?? ""
        let maxWidth: CGFloat = .greatestFiniteMagnitude
        let maxHeight: CGFloat = self.font.lineHeight
        let calculatedWidth = text.width(withConstrainedHeight: maxHeight, font: self.font)
        let calculatedHeight = text.height(withConstrainedWidth: maxWidth, font: self.font)
        return CGSize(width: calculatedWidth, height: calculatedHeight)
    }

    private func setupLabel(text: String) {
        self.text = text
        self.textColor = .black
        self.textAlignment = .center
        self.font = UIFont.systemFont(
            ofSize: Constants.fontSize - level * Constants.fontLevelMultiplier
        )
        let size = sizeForView()
        fixedHeight(size.height)
        fixedWidth(size.width)
    }
}

private extension BaseExpresionView {
    enum Constants {
        static let fontSize: CGFloat = 20
        static let fontLevelMultiplier: CGFloat = 6
        static let heightPadding: CGFloat = 2
        static let widthPadding: CGFloat = 3
    }
}
