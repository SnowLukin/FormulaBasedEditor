//
//  CurrentDocumentModels.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 25.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

enum CurrentDocument {

    struct Document: Hashable {
        var title: String
        var attributedText: NSAttributedString
        var base64Images: [String : String] // [Id : Value]
        var lastEditedDate: NSDate
    }

    enum UIComponents {
        struct EquationButtonViewModel {
            let title: String
            let imageName: String
        }
    }
    
    enum Save {
        struct Request {
            let title: String
            let attributedString: NSMutableAttributedString
        }
        
        struct Response {
            let success: Bool
            let error: Error?
        }
        
        struct ViewModel {
            let title: String
            let message: String
        }
    }
}
