// SwimMate/ViewModel/Extensions/Manager+DistanceFormatting.swift

import Foundation

extension Manager 
{
    func formatDistance(_ meters: Double) -> String
    {
        if preferredUnit == MeasureUnit.yards
        {
            let yards = meters * 1.09361
            return String(format: "%.1f yd", yards)
        } 
        else
        {
            return String(format: "%.1f m", meters)
        }
    }
}