// SwimMate/iOSViews/Components/Cards/DistanceChartCard.swift

import Charts
import SwiftUI

private func makeAggregatedSwim(date: Date, duration: Double, totalDistance: Double?, totalEnergyBurned: Double?) -> Swim
{
    return Swim(
        id: UUID(),
        startDate: date,
        endDate: date.addingTimeInterval(duration),
        totalDistance: totalDistance,
        totalEnergyBurned: totalEnergyBurned,
        poolLength: nil,
        laps: []
    )
}

// distance chart card w/ expanded date ranges & improved visualization
struct DistanceChartCard: View
{
    @EnvironmentObject var manager: Manager
    @State private var selectedRange: DataRange = .last30Days

    enum DataRange: String, CaseIterable
    {
        case last30Days = "Last 30 Days"
        case last6Months = "Last 6 Months"
        case lastYear = "Last Year"
        case allTime = "All Time"
    }

    var body: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack
            {
                Text("Distance Trends")
                    .font(.headline)

                Spacer()

                Picker("Select Range", selection: $selectedRange)
                {
                    ForEach(DataRange.allCases, id: \.self)
                    { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.menu)
            }

            if manager.chartDataFiltered(by: chartRangeString(selectedRange)).isEmpty
            {
                VStack(spacing: 12)
                {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary.opacity(0.6))

                    Text("No swim data available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Start swimming to see your trends!")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.8))
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
            }
            else
            {
                Chart(manager.chartDataFiltered(by: chartRangeString(selectedRange)))
                { swim in
                    if let distance = swim.totalDistance
                    {
                        LineMark(
                            x: .value("Date", swim.date),
                            y: .value("Distance", distance)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                }

                .frame(height: 220)
                .chartYAxis
                {
                    AxisMarks
                    { value in
                        if let distance = value.as(Double.self)
                        {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel
                            {
                                Text(manager.formatDistance(distance))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .chartXAxis
                {
                    AxisMarks(position: .bottom)
                    { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel
                        {
                            if let date = value.as(Date.self)
                            {
                                Text(manager.formatAxisLabel(for: date, range: chartRangeString(selectedRange)))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }

    private func chartRangeString(_ range: DataRange) -> String
    {
        switch range
        {
        case .last30Days:
            return "Month"
        case .last6Months:
            return "Quarter"
        case .lastYear:
            return "Year"
        case .allTime:
            return "Year"
        }
    }
}

#Preview
{
    let manager = Manager()
    return DistanceChartCard().environmentObject(manager)
}
