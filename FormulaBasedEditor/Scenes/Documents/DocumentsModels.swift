//
//  DocumentsModels.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 28.05.2023.
//  Copyright (c) 2023 Snow Lukin. All rights reserved.
//

import UIKit

enum Documents {
    struct Entity {
        var title: String
        var date: Date
        var attributedString: NSAttributedString
        var text: Data
    }

    struct Document: Hashable {
        var title: String
        var date: NSDate
        var attributedString: NSAttributedString
    }
    
    enum Save {
        struct Request {
            var title: String
            var attributedString: NSAttributedString
            var text: Data
        }
        struct Response {
            var result: Bool
        }
        struct ViewModel {
            var result: Bool
        }
    }
    
    enum Fetch {
        struct Request {}
        struct Response {
            var documents: [Entity]
        }
        struct ViewModel {
            var documents: [Document]
        }
    }
}
