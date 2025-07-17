// SwimMate/iOSViews/Components/Display/SimpleLapRow.swift

import SwiftUI

struct SimpleLapRow: View
{
    let lapNumber: Int
    let lap: Lap
    
    var body: some View
    {
        HStack
        {
            // Lap number
            Text("\(lapNumber)")
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 40, alignment: .leading)
            
            // Stroke type
            Text(lap.strokeStyle?.description ?? "Unknown")
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Time
            Text(String(format: "%.1fs", lap.duration))
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 60, alignment: .trailing)
            
            // SWOLF
            Text(lap.swolfScore != nil ? String(format: "%.1f", lap.swolfScore!) : "—")
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(lap.swolfScore != nil ? .white : .secondary)
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(lapNumber % 2 == 0 ? Color.clear : Color.secondary.opacity(0.05))
    }
}

#Preview
{
    let baseDate = Date()
    return VStack(spacing: 0) {
        // Preview with different stroke styles and scores
        SimpleLapRow(
            lapNumber: 1,
            lap: Lap(startDate: baseDate, endDate: baseDate.addingTimeInterval(45.2), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5])
        )
        
        SimpleLapRow(
            lapNumber: 2,
            lap: Lap(startDate: baseDate.addingTimeInterval(60), endDate: baseDate.addingTimeInterval(102.1), metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 26.8])
        )
        
        SimpleLapRow(
            lapNumber: 3,
            lap: Lap(startDate: baseDate.addingTimeInterval(120), endDate: baseDate.addingTimeInterval(164.7), metadata: ["HKSwimmingStrokeStyle": 4, "HKSWOLFScore": 29.2])
        )
        
        SimpleLapRow(
            lapNumber: 4,
            lap: Lap(startDate: baseDate.addingTimeInterval(180), endDate: baseDate.addingTimeInterval(223.8), metadata: ["HKSwimmingStrokeStyle": 5])
        )
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
