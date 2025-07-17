// SwimMate/Model/Types/StrokeStyle.swift

import Foundation

/// Swimming stroke types
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