//
//  AddDocumentButton.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 08.10.2023.
//

import UIKit

protocol AddDocumentDelegate: UIViewController {
    func onDocumentAddTapped(title: String)
}

final class AddDocumentButton: UIButton {
    
    weak var delegate: AddDocumentDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = .plain()
        configuration?.imagePadding = 5
        configuration?.image = UIImage(systemName: "square.and.pencil")
        imageView?.contentMode = .scaleAspectFit
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        
        addAction(UIAction { [weak self] _ in
            self?.addDocumentButtonTapped()
        }, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addDocumentButtonTapped() {
        let alertController = UIAlertController(
            title: "Новый документ",
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.placeholder = "Имя документа"
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)

        let submitAction = UIAlertAction(title: "Создать", style: .default) { [unowned alertController] _ in
            let answer = alertController.textFields![0]
            guard let title = answer.text else { return }
            self.delegate?.onDocumentAddTapped(title: title)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        delegate?.present(alertController, animated: true)
    }
}
