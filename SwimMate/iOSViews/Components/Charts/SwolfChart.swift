// SwimMate/iOSViews/Components/Charts/SwolfChart.swift

import Charts
import SwiftUI

struct SwolfChart: View
{
    let swim: Swim

    var validSwolfData: [(Int, Double)]
    {
        swim.laps.enumerated().compactMap
        { index, lap in
            if let swolf = lap.swolfScore
            {
                return (index + 1, swolf)
            }
            return nil
        }
    }

    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text("SWOLF Scores")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            if validSwolfData.isEmpty
            {
                Text("No SWOLF data available")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else
            {
                Chart
                {
                    ForEach(validSwolfData, id: \.0)
                    { lap, swolf in
                        LineMark(
                            x: .value("Lap", lap),
                            y: .value("SWOLF", swolf)
                        )
                        .foregroundStyle(Color.green)
                    }
                }
                .chartXAxis
                {
                    AxisMarks(position: .bottom, values: .automatic(desiredCount: 5))
                }
                .chartYAxis
                {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 4))
                }
            }
        }
    }
}

#Preview
{
    let baseDate = Date()
    let sampleLaps = [
        Lap(startDate: baseDate, endDate: baseDate.addingTimeInterval(45.2), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(startDate: baseDate.addingTimeInterval(60), endDate: baseDate.addingTimeInterval(102.1), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(startDate: baseDate.addingTimeInterval(120), endDate: baseDate.addingTimeInterval(164.7), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(startDate: baseDate.addingTimeInterval(180), endDate: baseDate.addingTimeInterval(223.8), metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(startDate: baseDate.addingTimeInterval(300), endDate: baseDate.addingTimeInterval(346.3), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 30.5]),
        Lap(startDate: baseDate.addingTimeInterval(360), endDate: baseDate.addingTimeInterval(401.9), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 27.3]),
    ]

    let sampleSwim = Swim(
        id: UUID(),
        startDate: baseDate,
        endDate: baseDate.addingTimeInterval(1920),
        totalDistance: 1425,
        totalEnergyBurned: 289,
        poolLength: 25.0,
        laps: sampleLaps
    )

    return VStack
    {
        SwolfChart(swim: sampleSwim)
            .frame(height: 200)
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
