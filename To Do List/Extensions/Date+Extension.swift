//
//  Date+Extension.swift
//  To Do List
//
//  Created by Konstantin Ryabtsev on 18.02.2022.
//

import Foundation

extension Date {
    var formatedShortDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    var formatedFullDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
