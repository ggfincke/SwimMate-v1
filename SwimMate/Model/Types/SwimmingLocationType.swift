import Foundation

/// Mirrors HealthKit's HKWorkoutSwimmingLocationType but without requiring HealthKit at call-sites.
public enum SwimmingLocationType: String, Codable
{
    case pool
    case openWater
    case unknown
}
