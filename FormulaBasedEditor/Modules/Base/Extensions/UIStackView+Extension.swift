//
//  UIStackView+Extension.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 05.09.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
