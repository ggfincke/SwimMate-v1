// SwimMate/iOSViews/Components/Charts/StrokeDistributionChart.swift

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

#Preview
{
    let sampleLaps = [
        Lap(duration: 45.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(duration: 42.1, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(duration: 44.7, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(duration: 43.8, metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(duration: 46.3, metadata: ["HKSwimmingStrokeStyle": 4, "HKSWOLFScore": 30.5]),
        Lap(duration: 41.9, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 27.3]),
        Lap(duration: 48.1, metadata: ["HKSwimmingStrokeStyle": 5, "HKSWOLFScore": 32.8]),
        Lap(duration: 44.2, metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 28.9])
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
        StrokeDistributionChart(swim: sampleSwim)
            .frame(height: 200)
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
