//
//  DocumentCell.swift
//  FormulaBasedEditor
//
//  Created by Denis Mandych on 29.08.2023.
//

import UIKit

final class DocumentCell: UITableViewCell {
    static let reuseIdentifier = "DocumentPreviewCell"

    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .vertical
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let previewLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    var item: Document? {
        didSet {
            titleLabel.text = item?.title
            previewLabel.text = item?.text?.string
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(hStack)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(previewLabel)

        hStack
            .leadingAndTrailing(Constants.hPadding)
            .top(Constants.vPadding)
            .bottom(Constants.vPadding)
    }
}

private enum Constants {
    static let hPadding: CGFloat = 12
    static let vPadding: CGFloat = 5
}
