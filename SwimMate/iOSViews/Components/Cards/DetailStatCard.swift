// SwimMate/iOSViews/Components/Cards/DetailStatCard.swift

import SwiftUI

struct DetailStatCard: View
{
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color

    var body: some View
    {
        VStack(spacing: 6)
        {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(height: 20)

            VStack(spacing: 1)
            {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                if !unit.isEmpty
                {
                    Text(unit)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(height: 36)

            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(height: 14)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview
{
    HStack(spacing: 12)
    {
        DetailStatCard(
            title: "Distance",
            value: "2800",
            unit: "meters",
            icon: "ruler",
            color: .blue
        )

        DetailStatCard(
            title: "Duration",
            value: "45",
            unit: "min",
            icon: "clock",
            color: .orange
        )

        DetailStatCard(
            title: "Difficulty",
            value: "Advanced",
            unit: "",
            icon: "chart.bar.fill",
            color: .red
        )
    }
    .padding()
}
