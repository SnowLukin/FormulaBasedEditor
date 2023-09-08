//
//  FormulaWorker.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 27.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

final class FormulaWorker {
    func renderFormulaView(with text: String) -> FormulaViewProtocol {
        FormulaFactory.createFormulaView(for: text)
    }
}
