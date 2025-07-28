// SwimMate/iOSViews/SwimViews/LogbookView/components/SwimListItemView.swift

import SwiftUI

struct SwimListItemView: View
{
    let swim: Swim
    @EnvironmentObject var manager: Manager

    private var dateFormatter: DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View
    {
        HStack(spacing: 16)
        {
            // Beautiful date circle with gradient
            VStack(spacing: 2)
            {
                Text("\(Calendar.current.component(.day, from: swim.date))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Text(swim.date.formatted(.dateTime.month(.abbreviated)))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(width: 50, height: 50)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Circle())
            .shadow(color: .blue.opacity(0.3), radius: 6, x: 0, y: 3)

            // Swim details section
            VStack(alignment: .leading, spacing: 8)
            {
                // Header with time and distance
                HStack
                {
                    Text(swim.date.formatted(.dateTime.hour().minute()))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)

                    Spacer()

                    if let distance = swim.totalDistance, distance > 0
                    {
                        HStack(spacing: 4)
                        {
                            Image(systemName: "ruler")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.blue)

                            Text(manager.formatDistance(distance))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }

                // Bottom row with duration and strokes
                HStack(spacing: 16)
                {
                    HStack(spacing: 4)
                    {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)

                        Text(formatDuration(swim.duration))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    if let strokes = getStrokes(from: swim)
                    {
                        HStack(spacing: 4)
                        {
                            Image(systemName: "figure.pool.swim")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)

                            Text(strokes)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }

                    Spacer()
                }
            }

            // Chevron indicator
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.6))
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
    }

    private func formatDuration(_ duration: TimeInterval) -> String
    {
        let minutes = Int(duration / 60)
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        if hours > 0
        {
            return "\(hours)h \(remainingMinutes)m"
        }
        else
        {
            return "\(minutes) min"
        }
    }

    private func getStrokes(from swim: Swim) -> String?
    {
        let uniqueStrokes = Set(swim.laps.compactMap { $0.stroke?.description })
        if uniqueStrokes.isEmpty
        {
            return nil
        }
        return uniqueStrokes.joined(separator: ", ")
    }
}

#Preview
{
    SwimListItemView(swim: Swim(
        id: UUID(),
        startDate: Date(),
        endDate: Date().addingTimeInterval(1800),
        totalDistance: 1000,
        totalEnergyBurned: 400,
        poolLength: 50
    ))
    .environmentObject(Manager())
}
