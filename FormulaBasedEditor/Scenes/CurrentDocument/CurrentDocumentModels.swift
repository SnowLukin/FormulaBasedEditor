//
//  CurrentDocumentModels.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

enum CurrentDocument {
    enum UIComponents {
        struct EquationButtonViewModel {
            let title: String
            let imageName: String
        }
    }
    
    enum FormulaParameters {
        struct Content {
            let content: String
            let range: NSRange
        }
    }
}
