// InsightRow.swift

import SwiftUI

// insight row
struct InsightRow: View
{
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View
    {
        HStack
        {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 16)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .truncationMode(.tail)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(color)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
    }
}

// preview
#Preview
{
    VStack(spacing: 8)
    {
        InsightRow(
            icon: "heart.fill",
            title: "Avg Heart Rate",
            value: "142 bpm",
            color: .red
        )
        
        InsightRow(
            icon: "flame.fill",
            title: "Calories Burned",
            value: "324 cal",
            color: .orange
        )
        
        InsightRow(
            icon: "timer",
            title: "Duration",
            value: "45:30",
            color: .blue
        )
        
        InsightRow(
            icon: "chart.line.uptrend.xyaxis",
            title: "Performance",
            value: "Nice Start",
            color: .green
        )
    }
}
