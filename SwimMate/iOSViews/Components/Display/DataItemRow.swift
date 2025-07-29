// SwimMate/iOSViews/Components/Display/DataItemRow.swift

import SwiftUI

struct DataItemRow: View
{
    let icon: String
    let title: String
    let description: String

    var body: some View
    {
        HStack(spacing: 12)
        {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2)
            {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

#Preview
{
    DataItemRow(icon: "figure.pool.swim", title: "Workout Data", description: "Swimming sessions, duration, distance, strokes")
}