// SwimMate/ViewModel/Extensions/Manager+Helpers.swift

import Foundation

extension Manager 
{
    func formatDuration(_ duration: TimeInterval) -> String
    {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    func getStrokes(from swim: Swim) -> String?
    {
        let uniqueStrokes = Set(swim.laps.compactMap { $0.stroke?.description })
        if uniqueStrokes.isEmpty 
        {
            return nil
        }
        return uniqueStrokes.joined(separator: ", ")
    }
    
    func filteredWorkouts(for timeFilter: String) -> [Swim]
    {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let dateLimit: Date? = 
        {
            switch timeFilter 
            {
            case "30 Days":
                return calendar.date(byAdding: .day, value: -30, to: currentDate)
            case "90 Days":
                return calendar.date(byAdding: .day, value: -90, to: currentDate)
            case "6 Months":
                return calendar.date(byAdding: .month, value: -6, to: currentDate)
            case "Year":
                return calendar.date(byAdding: .year, value: -1, to: currentDate)
            case "All Time":
                return nil
            default:
                return nil
            }
        }()
        
        if let dateLimit = dateLimit 
        {
            return swims.filter { swim in swim.date >= dateLimit }
                .sorted(by: { a, b in a.date > b.date })
        } 
        else 
        {
            return swims.sorted(by: { a, b in a.date > b.date })
        }
    }
    
    func displayedWorkouts(from filtered: [Swim], searchText: String) -> [Swim]
    {
        guard !searchText.isEmpty else { return filtered }
        
        return filtered.filter 
        { swim in
            let dateString = swim.date.formatted(.dateTime.weekday().month().day())
            let durationString = formatDuration(swim.duration)
            let strokesString = getStrokes(from: swim) ?? ""
            
            return dateString.localizedCaseInsensitiveContains(searchText) ||
                   durationString.localizedCaseInsensitiveContains(searchText) ||
                   strokesString.localizedCaseInsensitiveContains(searchText)
        }
    }
}