// SwimMate/iOSViews/SwimViews/WorkoutView/Sections/WorkoutHeaderCard.swift

import SwiftUI

// MARK: - Header Card (matches home screen style)
struct WorkoutHeaderCard: View
{
    let swim: Swim
    
    var body: some View
    {
        VStack(spacing: 16)
        {
            // Date and Time
            VStack(spacing: 4)
            {
                Text(swim.date, style: .date)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(swim.date, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Primary Stats Row
            HStack(spacing: 30)
            {
                StatColumn(
                    emoji: "⏱️",
                    value: formatDuration(swim.duration),
                    label: "Duration"
                )
                
                StatColumn(
                    emoji: "🌊",
                    value: formatDistance(swim.totalDistance),
                    label: "Distance"
                )
                
                StatColumn(
                    emoji: "🔥",
                    value: "\(Int(swim.totalEnergyBurned ?? 0))",
                    label: "Calories"
                )
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String
    {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func formatDistance(_ distance: Double?) -> String
    {
        guard let distance = distance else { return "N/A" }
        return String(format: "%.0f m", distance)
    }
}

#Preview
{
    let baseDate = Date()
    let sampleLaps = [
        Lap(startDate: baseDate, endDate: baseDate.addingTimeInterval(45.2), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(startDate: baseDate.addingTimeInterval(60), endDate: baseDate.addingTimeInterval(102.1), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(startDate: baseDate.addingTimeInterval(120), endDate: baseDate.addingTimeInterval(164.7), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2])
    ]

    let sampleSwim = Swim(
        id: UUID(),
        startDate: baseDate,
        endDate: baseDate.addingTimeInterval(1920),
        totalDistance: 1425,
        totalEnergyBurned: 289,
        poolLength: 25.0,
        laps: sampleLaps
    )

    return VStack {
        WorkoutHeaderCard(swim: sampleSwim)
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
