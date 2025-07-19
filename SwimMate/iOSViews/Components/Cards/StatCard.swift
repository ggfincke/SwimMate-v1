// SwimMate/iOSViews/Components/Cards/StatCard.swift

import SwiftUI

enum StatTrend
{
    case up, down, neutral
    
    var icon: String
    {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .neutral: return "minus"
        }
    }
    
    var color: Color
    {
        switch self {
        case .up: return .green
        case .down: return .red
        case .neutral: return .gray
        }
    }
}

struct StatCard: View
{
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: StatTrend
    
    var body: some View
    {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: trend.icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(trend.color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    StatCard(title: "Distance", value: "1.2 km", icon: "figure.pool.swim", color: .blue, trend: .up)
}
