// SwimMate/Model/Types/MeasureUnit.swift

import Foundation

/// Measurement units for swimming distances
enum MeasureUnit: String, CaseIterable, Codable
{
    case meters = "Meters"
    case yards = "Yards"
    
    var abbreviation: String 
    {
        switch self 
        {
            case .meters: return "m"
            case .yards: return "y"
        }
    }
    
    /// Convert to meters for calculations
    func toMeters(_ distance: Double) -> Double 
    {
        switch self 
        {
            case .meters: return distance
            case .yards: return distance * 0.9144
        }
    }
} 