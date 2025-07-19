// SwimMate/ViewModel/Extensions/Manager+DataFiltering.swift

import Foundation

extension Manager 
{
    func filteredWorkouts(searchText: String, dateFilter: String) -> [Swim]
    {
        var filtered = swims
        
        // Apply search filter
        if !searchText.isEmpty 
        {
            filtered = filtered.filter { swim in
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let dateString = dateFormatter.string(from: swim.date)
                return dateString.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply date filter
        let calendar = Calendar.current
        let now = Date()
        
        switch dateFilter 
        {
        case "This Week":
            if let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start 
            {
                filtered = filtered.filter { $0.date >= weekStart }
            }
        case "This Month":
            if let monthStart = calendar.dateInterval(of: .month, for: now)?.start 
            {
                filtered = filtered.filter { $0.date >= monthStart }
            }
        case "Last 3 Months":
            if let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now) 
            {
                filtered = filtered.filter { $0.date >= threeMonthsAgo }
            }
        default:
            break
        }
        
        return filtered.sorted { a, b in a.date > b.date }
    }
}