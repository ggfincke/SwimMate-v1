//
//  WorkoutHeaderCard.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

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
    let sampleLaps = [
        Lap(duration: 45.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(duration: 42.1, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(duration: 44.7, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2])
    ]

    let sampleSwim = Swim(
        id: UUID(),
        date: Date(),
        duration: 1920,
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
