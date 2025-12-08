//
//  DateExtension.swift
//  pontoapp
//
//  Created by Erick Costa on 06/12/25.
//

import Foundation

struct DateValue: Identifiable{
    var id = UUID()
    var day: Int
    var date: Date
}

extension Date {
    func formatMonthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMM yyyy"
        
        return formatter.string(from: self)
    }
    
    func daysOfMonth() -> [DateValue] {
        let calendar = Calendar.current

        guard let currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) else {
            return []
        }
        
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth) else {
            return []
        }
        
        let firstDayOfMonth = currentMonth
        let daysOfWeek = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        var days: [DateValue] = []
        
        for _ in 0..<daysOfWeek {
            days.append(DateValue(day: -1, date: Date()))
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: currentMonth){
                days.append(DateValue(day: day, date: date))
            }
        }
        
        return days
    }
}
