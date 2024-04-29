//
//  Swim.swift
//  SwimMate
//
//  Created by Garrett Fincke on 4/11/24.
//

// this file is for all information on a specific swim workout.
// can be imported from iOS fitness or will be created from the watch app
import Foundation
import HealthKit

class Swim: Identifiable, Codable {
    let id: UUID
    let date: Date
    let duration: TimeInterval
    let totalDistance: Double?
    let totalEnergyBurned: Double?
    var poolLength: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case duration
        case totalDistance
        case totalEnergyBurned
        case poolLength
    }

    init(id: UUID, date: Date, duration: TimeInterval, totalDistance: Double?, totalEnergyBurned: Double?, poolLength: Double?) {
        self.id = id
        self.date = date
        self.duration = duration
        self.totalDistance = totalDistance
        self.totalEnergyBurned = totalEnergyBurned
        self.poolLength = poolLength
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        totalDistance = try container.decodeIfPresent(Double.self, forKey: .totalDistance)
        totalEnergyBurned = try container.decodeIfPresent(Double.self, forKey: .totalEnergyBurned)
        poolLength = try container.decodeIfPresent(Double.self, forKey: .poolLength)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(totalDistance, forKey: .totalDistance)
        try container.encodeIfPresent(totalEnergyBurned, forKey: .totalEnergyBurned)
        try container.encodeIfPresent(poolLength, forKey: .poolLength)
    }
}

