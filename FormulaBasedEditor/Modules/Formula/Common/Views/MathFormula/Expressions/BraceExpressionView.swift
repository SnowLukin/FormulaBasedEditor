//
//  BraceExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 06.08.2023.
//

import UIKit

class BraceExpressionView: UIView, ExpressionView {

    var level: CGFloat
    var height: CGFloat
    private var side: Side
    private let imageView = UIImageView()

    init(side: Side, height: CGFloat = 0, level: CGFloat) {
        self.level = level
        self.height = height
        self.side = side
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sizeForView() -> CGSize {
        let height = height + Constants.heightPadding
        let width = height * Constants.widthMultiplier
        return CGSize(width: width, height: height)
    }

    private func setupViews() {
        addSubview(imageView)

        setupImageView()

        let size = sizeForView()
        fixedWidth(size.width)
        fixedHeight(size.height)
        imageView
            .fitToSuperview()
    }

    private func setupImageView() {
        let imageName = side == .left ? Constants.leftBraceAsset : Constants.rightBraceAsset
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
}

extension BraceExpressionView {
    enum Side {
        case left
        case right
    }

    private enum Constants {
        static let leftBraceAsset = "leftBrace"
        static let rightBraceAsset = "rightBrace"
        static let heightPadding: CGFloat = 4
        static let widthMultiplier: CGFloat = 1 / 4.11
    }
}
