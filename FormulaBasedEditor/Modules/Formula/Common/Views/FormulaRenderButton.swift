//
//  FormulaRenderButton.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

final class FormulaRenderButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        configuration = .filled()
        configuration?.title = "Вставить формулу"
        configuration?.baseBackgroundColor = .secondarySystemBackground
        configuration?.cornerStyle = .small
        configuration?.baseForegroundColor = .label
    }
}
