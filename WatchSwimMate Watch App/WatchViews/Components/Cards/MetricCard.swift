// MetricCard.swift

import SwiftUI

// metric cards for workout usage
struct WatchMetricCard: View
{
    let title: String
    let value: String
    let unit: String
    let color: Color
    let icon: String
    let isCompact: Bool
    
    // responsive sizing properties
    private var iconSize: CGFloat
    {
        isCompact ? 8 : 10
    }
    
    private var valueFontSize: CGFloat
    {
        isCompact ? 12 : 16
    }
    
    private var unitFontSize: CGFloat
    {
        isCompact ? 8 : 9
    }
    
    private var minHeight: CGFloat
    {
        isCompact ? 24 : 32
    }
    
    private var verticalPadding: CGFloat
    {
        isCompact ? 6 : 8
    }
    
    private var cornerRadius: CGFloat
    {
        isCompact ? 12 : 16
    }
    
    private var strokeWidth: CGFloat
    {
        isCompact ? 0.3 : 0.5
    }
    
    var body: some View
    {
        VStack(spacing: isCompact ? 3 : 4)
        {
            Image(systemName: icon)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundColor(color)
            
            HStack(alignment: .lastTextBaseline, spacing: unit.isEmpty ? 0 : 2)
            {
                Text(value)
                    .font(.system(size: valueFontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                if !unit.isEmpty
                {
                    Text(unit)
                        .font(.system(size: unitFontSize, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: minHeight)
        .padding(.vertical, verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color.opacity(0.1))
                .stroke(color.opacity(0.3), lineWidth: strokeWidth)
        )
    }
}

// preview
#Preview("Standard Size")
{
    VStack(spacing: 12)
    {
        HStack(spacing: 8)
        {
            WatchMetricCard(
                title: "Heart Rate",
                value: "132",
                unit: "bpm",
                color: .red,
                icon: "heart.fill",
                isCompact: false
            )
            
            WatchMetricCard(
                title: "Calories",
                value: "285",
                unit: "kcal",
                color: .orange,
                icon: "flame.fill",
                isCompact: false
            )
        }
        
        HStack(spacing: 8)
        {
            WatchMetricCard(
                title: "Laps",
                value: "15",
                unit: "laps",
                color: .green,
                icon: "arrow.clockwise",
                isCompact: false
            )
            
            WatchMetricCard(
                title: "Pace",
                value: "2:15",
                unit: "/100m",
                color: .purple,
                icon: "speedometer",
                isCompact: false
            )
        }
    }
    .padding()
}

#Preview("Compact Size")
{
    VStack(spacing: 6)
    {
        HStack(spacing: 6)
        {
            WatchMetricCard(
                title: "Heart Rate",
                value: "132",
                unit: "bpm",
                color: .red,
                icon: "heart.fill",
                isCompact: true
            )
            
            WatchMetricCard(
                title: "Calories",
                value: "285",
                unit: "kcal",
                color: .orange,
                icon: "flame.fill",
                isCompact: true
            )
        }
        
        HStack(spacing: 6)
        {
            WatchMetricCard(
                title: "Laps",
                value: "15",
                unit: "laps",
                color: .green,
                icon: "arrow.clockwise",
                isCompact: true
            )
            
            WatchMetricCard(
                title: "Pace",
                value: "2:15",
                unit: "/100m",
                color: .purple,
                icon: "speedometer",
                isCompact: true
            )
        }
    }
    .padding()
}
