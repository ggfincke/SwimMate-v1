// SwimMate/Model/Workout/Swim.swift

import Foundation
import HealthKit

/// Core swim workout data model
class Swim: Identifiable, Codable
{
    // MARK: - Core Properties

    let id: UUID
    let startDate: Date
    let endDate: Date

    // MARK: - Computed Properties

    /// Duration is derived from start and end dates
    var duration: TimeInterval
    { endDate.timeIntervalSince(startDate) }

    /// Date property for compatibility
    var date: Date
    { startDate }

    // MARK: - Location & Pool Information

    var locationType: SwimmingLocationType
    var poolLength: Double?
    var poolUnit: MeasureUnit?

    // MARK: - Health & Performance Metrics

    let totalDistance: Double?
    let totalEnergyBurned: Double?

    // MARK: - Lap Details

    var laps: [Lap]

    // MARK: - Initialization

    init(id: UUID,
         startDate: Date,
         endDate: Date,
         totalDistance: Double?,
         totalEnergyBurned: Double?,
         poolLength: Double?,
         locationType: SwimmingLocationType = .unknown,
         poolUnit: MeasureUnit? = nil,
         laps: [Lap] = [])
    {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.totalDistance = totalDistance
        self.totalEnergyBurned = totalEnergyBurned
        self.poolLength = poolLength
        self.locationType = locationType
        self.poolUnit = poolUnit
        self.laps = laps
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey
    {
        case id, startDate, endDate, totalDistance, totalEnergyBurned, poolLength, locationType, poolUnit, laps
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        totalDistance = try container.decodeIfPresent(Double.self, forKey: .totalDistance)
        totalEnergyBurned = try container.decodeIfPresent(Double.self, forKey: .totalEnergyBurned)
        poolLength = try container.decodeIfPresent(Double.self, forKey: .poolLength)
        locationType = try container.decodeIfPresent(SwimmingLocationType.self, forKey: .locationType) ?? .unknown
        poolUnit = try container.decodeIfPresent(MeasureUnit.self, forKey: .poolUnit)
        laps = try container.decodeIfPresent([Lap].self, forKey: .laps) ?? []
    }

    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(locationType, forKey: .locationType)
        try container.encodeIfPresent(totalDistance, forKey: .totalDistance)
        try container.encodeIfPresent(totalEnergyBurned, forKey: .totalEnergyBurned)
        try container.encodeIfPresent(poolLength, forKey: .poolLength)
        try container.encodeIfPresent(poolUnit, forKey: .poolUnit)
        try container.encode(laps, forKey: .laps)
    }
}
