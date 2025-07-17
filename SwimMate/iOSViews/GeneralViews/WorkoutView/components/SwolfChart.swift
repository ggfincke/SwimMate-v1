//
//  SwolfChart.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI
import Charts

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
