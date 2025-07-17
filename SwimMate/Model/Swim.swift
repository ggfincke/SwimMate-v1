// SwimMate/Model/Swim.swift

// this file is for all information on a specific swim workout.
// can be imported from iOS fitness or will be created in watch app 
import Foundation
import HealthKit

class Swim: Identifiable, Codable 
{
    // Core identifiers
    let id: UUID

    // time info
    let startDate: Date
    let endDate: Date
    // Duration is now derived
    var duration: TimeInterval { endDate.timeIntervalSince(startDate) }
    // prev date
    var date: Date { startDate }

    // Location & pool information
    var locationType: SwimmingLocationType
    var poolLength: Double?

    // Health / performance metrics
    let totalDistance: Double?
    let totalEnergyBurned: Double?

    // Lap details
    var laps: [Lap]

    // coding keys
    enum CodingKeys: String, CodingKey
    {
        case id, startDate, endDate, date, duration, totalDistance, totalEnergyBurned, poolLength, locationType, laps
    }

    // init
    init(id: UUID,
         startDate: Date,
         endDate: Date,
         totalDistance: Double?,
         totalEnergyBurned: Double?,
         poolLength: Double?,
         locationType: SwimmingLocationType = .unknown,
         laps: [Lap] = [])
    {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.totalDistance = totalDistance
        self.totalEnergyBurned = totalEnergyBurned
        self.poolLength = poolLength
        self.locationType = locationType
        self.laps = laps
    }

    // conv init to keep existing call-sites working
    /// old `date` + `duration` into `startDate` & `endDate`.
    convenience init(id: UUID,
                     date: Date,
                     duration: TimeInterval,
                     totalDistance: Double?,
                     totalEnergyBurned: Double?,
                     poolLength: Double?,
                     laps: [Lap] = [])
    {
        self.init(id: id,
                  startDate: date,
                  endDate: date.addingTimeInterval(duration),
                  totalDistance: totalDistance,
                  totalEnergyBurned: totalEnergyBurned,
                  poolLength: poolLength,
                  locationType: .unknown,
                  laps: laps)
    }

    // decoding from swim
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        if let start = try container.decodeIfPresent(Date.self, forKey: .startDate),
           let end = try container.decodeIfPresent(Date.self, forKey: .endDate) {
            self.startDate = start
            self.endDate = end
        } 
        else
        {
            let timestamp = try container.decodeIfPresent(Double.self, forKey: .date) ?? Date().timeIntervalSince1970
            let legacyDuration = try container.decodeIfPresent(TimeInterval.self, forKey: .duration) ?? 0
            self.startDate = Date(timeIntervalSince1970: timestamp)
            self.endDate = self.startDate.addingTimeInterval(legacyDuration)
        }

        totalDistance = try container.decodeIfPresent(Double.self, forKey: .totalDistance)
        totalEnergyBurned = try container.decodeIfPresent(Double.self, forKey: .totalEnergyBurned)
        poolLength = try container.decodeIfPresent(Double.self, forKey: .poolLength)
        locationType = try container.decodeIfPresent(SwimmingLocationType.self, forKey: .locationType) ?? .unknown
        laps = try container.decodeIfPresent([Lap].self, forKey: .laps) ?? []
    }

    // encoding from swim
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(locationType, forKey: .locationType)
        try container.encode(startDate.timeIntervalSince1970, forKey: .date)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(totalDistance, forKey: .totalDistance)
        try container.encodeIfPresent(totalEnergyBurned, forKey: .totalEnergyBurned)
        try container.encodeIfPresent(poolLength, forKey: .poolLength)
        try container.encode(laps, forKey: .laps)

    }
}

// elements of a lap
struct Lap: Codable, Hashable
{
    let duration: TimeInterval
    let strokeStyle: StrokeStyle?
    let swolfScore: Double?

    init(duration: TimeInterval, metadata: [String: Any]) 
    {
        self.duration = duration
        self.strokeStyle = StrokeStyle(rawValue: metadata["HKSwimmingStrokeStyle"] as? Int ?? 0)
        self.swolfScore = metadata["HKSWOLFScore"] as? Double
    }
}


// enum StrokeStyle
enum StrokeStyle: Int, Codable
{
    case unknown = 0
    case mixed = 1
    case freestyle = 2
    case backstroke = 3
    case breaststroke = 4
    case butterfly = 5
    case kickboard = 6

    var description: String {
        switch self {
        case .unknown: return "Unknown"
        case .mixed: return "Mixed"
        case .freestyle: return "Freestyle"
        case .backstroke: return "Backstroke"
        case .breaststroke: return "Breaststroke"
        case .butterfly: return "Butterfly"
        case .kickboard: return "Kickboard"
        }
    }
}
