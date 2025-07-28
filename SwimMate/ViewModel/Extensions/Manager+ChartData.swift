// SwimMate/ViewModel/Extensions/Manager+ChartData.swift

import Foundation

extension Manager
{
    func aggregateSwimsByWeek() -> [Swim]
    {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: swims)
        { swim in
            calendar.dateInterval(of: .weekOfYear, for: swim.date)?.start ?? swim.date
        }

        return grouped.map
        { week, swims in
            let duration = swims.reduce(0) { total, swim in total + swim.duration }
            let totalDistance = swims.compactMap { $0.totalDistance }.reduce(0, +)
            let totalEnergyBurned = swims.compactMap { $0.totalEnergyBurned }.reduce(0, +)

            return Swim(
                id: UUID(),
                startDate: week,
                endDate: week.addingTimeInterval(duration),
                totalDistance: totalDistance,
                totalEnergyBurned: totalEnergyBurned,
                poolLength: nil,
                locationType: .unknown,
                laps: []
            )
        }.sorted(by: { a, b in a.date < b.date })
    }

    func aggregateSwimsByQuarter() -> [Swim]
    {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: swims)
        { swim in
            let components = calendar.dateComponents([.year, .quarter], from: swim.date)
            return calendar.date(from: components) ?? swim.date
        }

        return grouped.map
        { quarter, swims in
            let duration = swims.reduce(0) { total, swim in total + swim.duration }
            let totalDistance = swims.compactMap { $0.totalDistance }.reduce(0, +)
            let totalEnergyBurned = swims.compactMap { $0.totalEnergyBurned }.reduce(0, +)

            return Swim(
                id: UUID(),
                startDate: quarter,
                endDate: quarter.addingTimeInterval(duration),
                totalDistance: totalDistance,
                totalEnergyBurned: totalEnergyBurned,
                poolLength: nil,
                locationType: .unknown,
                laps: []
            )
        }.sorted(by: { a, b in a.date < b.date })
    }

    func formatAxisLabel(for date: Date, range: String) -> String
    {
        let formatter = DateFormatter()

        switch range
        {
        case "Week":
            formatter.dateFormat = "M/d"
        case "Month":
            formatter.dateFormat = "M/d"
        case "Quarter":
            formatter.dateFormat = "MMM"
        case "Year":
            formatter.dateFormat = "MMM"
        default:
            formatter.dateFormat = "M/d"
        }

        return formatter.string(from: date)
    }

    func chartDataFiltered(by range: String) -> [Swim]
    {
        let calendar = Calendar.current
        let now = Date()
        var filtered: [Swim]

        switch range
        {
        case "Week":
            if let weekStart = calendar.date(byAdding: .day, value: -7, to: now)
            {
                filtered = swims.filter { $0.date >= weekStart }
            }
            else
            {
                filtered = swims
            }
            return aggregateSwimsByWeek().filter { swim in filtered.contains { filteredSwim in filteredSwim.date >= swim.date } }

        case "Month":
            if let monthStart = calendar.date(byAdding: .month, value: -1, to: now)
            {
                filtered = swims.filter { $0.date >= monthStart }
            }
            else
            {
                filtered = swims
            }
            return aggregateSwimsByWeek().filter { swim in filtered.contains { filteredSwim in filteredSwim.date >= swim.date } }

        case "Quarter":
            if let quarterStart = calendar.date(byAdding: .month, value: -3, to: now)
            {
                filtered = swims.filter { $0.date >= quarterStart }
            }
            else
            {
                filtered = swims
            }
            return aggregateSwimsByWeek().filter { swim in filtered.contains { filteredSwim in filteredSwim.date >= swim.date } }

        case "Year":
            if let yearStart = calendar.date(byAdding: .year, value: -1, to: now)
            {
                filtered = swims.filter { $0.date >= yearStart }
            }
            else
            {
                filtered = swims
            }
            return aggregateSwimsByQuarter().filter { swim in filtered.contains { filteredSwim in filteredSwim.date >= swim.date } }

        default:
            return aggregateDataByMonth(swims: swims)
        }
    }
}
