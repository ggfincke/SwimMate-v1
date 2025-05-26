// MetricCard

import SwiftUI

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(color)
            
            HStack(alignment: .lastTextBaseline, spacing: unit.isEmpty ? 0 : 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .monospacedDigit()
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
        // need to set min height
        .frame(maxWidth: .infinity, minHeight: 40)
//        .aspectRatio(1.7, contentMode: .fit)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .stroke(color.opacity(0.3), lineWidth: 0.5)
        )
    }
}

// misaligned in preview, fine in the grid view though
#Preview {
    HStack(spacing: 12) {
        MetricCard(
            title: "Heart Rate",
            value: "132",
            unit: "bpm",
            color: .red,
            icon: "heart.fill"
        )
        
        MetricCard(
            title: "Steps",
            value: "4,280",
            unit: "",
            color: .green,
            icon: "figure.walk"
        )
    }
    .padding()
}
