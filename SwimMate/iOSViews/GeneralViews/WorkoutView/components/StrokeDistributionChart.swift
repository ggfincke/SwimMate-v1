//
//  StrokeDistributionChart.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI
import Charts

struct StrokeDistributionChart: View
{
    let swim: Swim
    
    var strokeData: [(String, Int)]
    {
        let strokeCounts = Dictionary(grouping: swim.laps)
        { lap in
            lap.strokeStyle?.description ?? "Unknown"
        }.mapValues { $0.count }
        
        return strokeCounts.map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
    }
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text("Stroke Distribution")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            HStack
            {
                // Simple chart
                Chart(strokeData, id: \.0)
                { stroke, count in
                    SectorMark(
                        angle: .value("Count", count),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(0.8)
                    )
                    .foregroundStyle(by: .value("Stroke", stroke))
                }
                .frame(width: 120, height: 120)
                
                // Legend
                VStack(alignment: .leading, spacing: 4)
                {
                    ForEach(strokeData.prefix(4), id: \.0) { stroke, count in
                        HStack
                        {
                            Circle()
                                .fill(strokeColor(for: stroke))
                                .frame(width: 8, height: 8)
                            
                            Text(stroke)
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private func strokeColor(for stroke: String) -> Color
    {
        switch stroke
        {
        case "Freestyle": return .blue
        case "Backstroke": return .green
        case "Breaststroke": return .orange
        case "Butterfly": return .purple
        case "Mixed": return .yellow
        default: return .gray
        }
    }
}
