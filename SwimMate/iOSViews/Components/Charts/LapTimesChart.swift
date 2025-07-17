//
//  LapTimesChart.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI
import Charts

// MARK: - Simplified Charts
struct LapTimesChart: View
{
    let swim: Swim
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text("Lap Times")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Chart
            {
                ForEach(Array(swim.laps.enumerated()), id: \.offset)
                { index, lap in
                    LineMark(
                        x: .value("Lap", index + 1),
                        y: .value("Time", lap.duration)
                    )
                    .foregroundStyle(Color.blue)
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

#Preview
{
    let sampleLaps = [
        Lap(duration: 45.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(duration: 42.1, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(duration: 44.7, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(duration: 43.8, metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(duration: 46.3, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 30.5]),
        Lap(duration: 41.9, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 27.3])
    ]

    let sampleSwim = Swim(
        id: UUID(),
        date: Date(),
        duration: 1920,
        totalDistance: 1425,
        totalEnergyBurned: 289,
        poolLength: 25.0,
        laps: sampleLaps
    )

    return VStack {
        LapTimesChart(swim: sampleSwim)
            .frame(height: 200)
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
