//
//  UIViewController+Extension.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.10.2023.
//

import UIKit
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    }
    
    func showPreview() -> some View {
        Preview(viewController: self)
    }
}
