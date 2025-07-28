// SwimMate/iOSViews/Components/Display/StatColumn.swift

import SwiftUI

// MARK: - Supporting Views

struct StatColumn: View
{
    let emoji: String
    let value: String
    let label: String

    var body: some View
    {
        VStack(spacing: 8)
        {
            Text(emoji)
                .font(.system(size: 28))

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 2)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview
{
    HStack(spacing: 30)
    {
        StatColumn(
            emoji: "⏱️",
            value: "32:00",
            label: "Duration"
        )

        StatColumn(
            emoji: "🌊",
            value: "1425 m",
            label: "Distance"
        )

        StatColumn(
            emoji: "🔥",
            value: "289",
            label: "Calories"
        )
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
