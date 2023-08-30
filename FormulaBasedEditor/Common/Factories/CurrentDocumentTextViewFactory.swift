//
//  CurrentDocumentTextViewFactory.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//

import Foundation

enum CurrentDocumentTextViewFactory {
    static func makeDocumentTextView(withFrame frame: CGRect) -> CurrentDocumentTextView {
        let documentTextView = CurrentDocumentTextView(usingTextLayoutManager: false)
        documentTextView.frame = frame

        documentTextView.autocorrectionType = .no
        documentTextView.autocapitalizationType = .none
        documentTextView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        documentTextView.font = .systemFont(ofSize: 20)
        return documentTextView
    }
}
