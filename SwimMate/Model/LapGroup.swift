import Foundation

// gropu consec laps of same stroke style; set within a workout
struct LapGroup: Hashable, Codable 
{
    let strokeStyle: StrokeStyle?
    let laps: [Lap]
    let startLapNumber: Int
    
    init(strokeStyle: StrokeStyle?, laps: [Lap], startLapNumber: Int) 
    {
        self.strokeStyle = strokeStyle
        self.laps = laps
        self.startLapNumber = startLapNumber
    }
    
    var totalTime: TimeInterval 
    {
        laps.reduce(0) { $0 + $1.duration }
    }
    
    var averageTime: TimeInterval 
    {
        guard !laps.isEmpty else { return 0 }
        return totalTime / Double(laps.count)
    }
    
    var averageSwolf: Double? 
    {
        let scores = laps.compactMap { $0.swolfScore }
        guard !scores.isEmpty else { return nil }
        return scores.reduce(0, +) / Double(scores.count)
    }
    
    var displayTitle: String 
    {
        let count = laps.count
        let strokeName = strokeStyle?.description ?? "Unknown"
        return count > 1 ? "\(count)x \(strokeName)" : strokeName
    }
} 
