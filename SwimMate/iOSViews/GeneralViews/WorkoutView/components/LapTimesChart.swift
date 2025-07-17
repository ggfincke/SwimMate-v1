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
