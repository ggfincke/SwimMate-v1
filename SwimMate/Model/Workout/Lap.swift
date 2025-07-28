// SwimMate/Model/Workout/Lap.swift

import Foundation

/// Individual lap data within a swimming workout
struct Lap: Codable, Hashable
{
    // MARK: - Properties

    let duration: TimeInterval
    let stroke: SwimStroke?
    let swolfScore: Double?
    let startDate: Date
    let endDate: Date

    // MARK: - Initialization

    init(duration: TimeInterval, metadata: [String: Any])
    {
        self.duration = duration
        stroke = SwimStroke(rawValue: metadata["HKSwimmingStrokeStyle"] as? Int ?? 0)
        swolfScore = metadata["HKSWOLFScore"] as? Double
        // For legacy data without timing info, use current time as default
        startDate = Date()
        endDate = Date().addingTimeInterval(duration)
    }

    init(startDate: Date, endDate: Date, metadata: [String: Any])
    {
        self.startDate = startDate
        self.endDate = endDate
        duration = endDate.timeIntervalSince(startDate)
        stroke = SwimStroke(rawValue: metadata["HKSwimmingStrokeStyle"] as? Int ?? 0)
        swolfScore = metadata["HKSWOLFScore"] as? Double
    }

    // MARK: - Methods

    /// Calculate rest period to next lap
    func restPeriodTo(_ nextLap: Lap) -> TimeInterval
    {
        return nextLap.startDate.timeIntervalSince(endDate)
    }
}
