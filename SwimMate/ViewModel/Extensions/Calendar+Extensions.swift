// SwimMate/ViewModel/Extensions/Calendar+Extensions.swift

import Foundation

extension Calendar 
{
    func startOfMonth(for date: Date) -> Date 
    {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
}