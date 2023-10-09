//
//  Date+Extension.swift
//  FormulaBasedEditor
//
//  Created by Snow Lukin on 07.09.2023.
//

import Foundation

extension Date {
    func formatedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = Calendar.current.component(.year, from: self)
        
        if Calendar.current.isDateInToday(self) {
            dateFormatter.dateFormat = "hh:mm"
        } else if year == currentYear {
            dateFormatter.dateFormat = "dd MMMM"
        } else {
            dateFormatter.dateFormat = "dd MMMM, yyyy"
        }
        
        return dateFormatter.string(from: self)
    }
}
