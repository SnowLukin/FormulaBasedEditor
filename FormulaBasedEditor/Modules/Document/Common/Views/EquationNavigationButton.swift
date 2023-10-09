//
//  EquationNavigationButton.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

final class EquationNavigationButton: UIButton {
    private lazy var equationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Формула"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var equationImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "x.squareroot"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var equationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 3
        view.isUserInteractionEnabled = false
        
        addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        equationStackView.addArrangedSubviews(equationTitleLabel, equationImage)
        
        equationStackView
            .fitToSuperview()
        equationImage
            .fixedWidth(20)
            .fixedHeight(20)
    }
    
    private func setupAccessibility() {
        
    }
}
