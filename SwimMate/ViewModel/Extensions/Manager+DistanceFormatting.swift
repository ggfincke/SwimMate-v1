// SwimMate/ViewModel/Extensions/Manager+DistanceFormatting.swift

import Foundation

extension Manager
{
    func formatDistance(_ distance: Double) -> String
    {
        return formatDistance(distance, unit: preferredUnit)
    }

    func formatDistance(_ distance: Double, unit: MeasureUnit?) -> String
    {
        let displayUnit = unit ?? preferredUnit

        if displayUnit == MeasureUnit.yards
        {
            return String(format: "%.1f yd", distance)
        }
        else
        {
            return String(format: "%.1f m", distance)
        }
    }
}
