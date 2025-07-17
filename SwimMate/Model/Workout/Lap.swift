// SwimMate/Model/Workout/Lap.swift

import Foundation

/// Individual lap data within a swimming workout
struct Lap: Codable, Hashable
{
    // MARK: - Properties
    let duration: TimeInterval
    let strokeStyle: StrokeStyle?
    let swolfScore: Double?
    let startDate: Date
    let endDate: Date

    // MARK: - Initialization
    init(duration: TimeInterval, metadata: [String: Any]) 
    {
        self.duration = duration
        self.strokeStyle = StrokeStyle(rawValue: metadata["HKSwimmingStrokeStyle"] as? Int ?? 0)
        self.swolfScore = metadata["HKSWOLFScore"] as? Double
        // For legacy data without timing info, use current time as default
        self.startDate = Date()
        self.endDate = Date().addingTimeInterval(duration)
    }
    
    init(startDate: Date, endDate: Date, metadata: [String: Any]) 
    {
        self.startDate = startDate
        self.endDate = endDate
        self.duration = endDate.timeIntervalSince(startDate)
        self.strokeStyle = StrokeStyle(rawValue: metadata["HKSwimmingStrokeStyle"] as? Int ?? 0)
        self.swolfScore = metadata["HKSWOLFScore"] as? Double
    }
    
    // MARK: - Methods
    /// Calculate rest period to next lap
    func restPeriodTo(_ nextLap: Lap) -> TimeInterval {
        return nextLap.startDate.timeIntervalSince(self.endDate)
    }
} 