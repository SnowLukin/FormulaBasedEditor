//
//  FormulaWorker.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 27.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

class FormulaWorker {
    func renderFormulaView(with text: String) -> UIView {
        FormulaFactory.createFormulaView(for: text)
    }
}
