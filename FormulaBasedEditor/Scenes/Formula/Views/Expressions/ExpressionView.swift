//
//  ExpressionView.swift
//  braille-workspace-pages
//
//  Created by Denis Mandych on 30.07.2023.
//

import UIKit

protocol ExpressionView: UIView {
    var level: CGFloat { get }
    func sizeForView() -> CGSize
}
