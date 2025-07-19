// SwimMate/ViewModel/Extensions/Manager+DataAggregation.swift

import Foundation

extension Manager
{
    func aggregateDataByMonth(swims: [Swim]) -> [Swim]
    {
        let grouped = Dictionary(grouping: swims)
        { (swim) in
            Calendar.current.startOfMonth(for: swim.date)
        }
        return grouped.map
        { (month, swims) in
            let duration = swims.reduce(0, { total, swim in total + swim.duration })
            let totalDistance = swims.compactMap({ $0.totalDistance }).reduce(0, +)
            let totalEnergyBurned = swims.compactMap({ $0.totalEnergyBurned }).reduce(0, +)
            return Swim(
                id: UUID(),
                startDate: month,
                endDate: month.addingTimeInterval(duration),
                totalDistance: totalDistance,
                totalEnergyBurned: totalEnergyBurned,
                poolLength: nil,
                locationType: .unknown,
                laps: []
            )
        }.sorted(by: { (a, b) in a.date < b.date })
    }
}