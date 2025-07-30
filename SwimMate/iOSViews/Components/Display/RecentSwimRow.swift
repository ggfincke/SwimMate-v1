// SwimMate/iOSViews/Components/Display/RecentSwimRow.swift

import SwiftUI

// recent swim row
struct RecentSwimRow: View
{
    let swim: Swim
    @EnvironmentObject var manager: Manager

    private var dateFormatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }

    var body: some View
    {
        HStack(alignment: .center)
        {
            VStack(alignment: .leading, spacing: 4)
            {
                Text(dateFormatter.string(from: swim.date))
                    .font(.subheadline)
                    .foregroundColor(.primary)

                if let distance = swim.totalDistance
                {
                    Text(manager.formatDistance(distance, unit: swim.poolUnit))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("\(Int(swim.duration / 60)) min")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview
{
    let start = Date()
    return RecentSwimRow(swim: Swim(
        id: UUID(),
        startDate: start,
        endDate: start.addingTimeInterval(1800),
        totalDistance: 1000,
        totalEnergyBurned: 400,
        poolLength: 50
    ))
    .environmentObject(Manager())
}
