// SwimMate/iOSViews/SwimViews/WorkoutView/Sections/KeyMetricsGrid.swift

import SwiftUI

// MARK: - Key Metrics Grid (matches home screen style)

struct KeyMetricsGrid: View
{
    @EnvironmentObject var manager: Manager
    let swim: Swim

    var body: some View
    {
        VStack(alignment: .leading, spacing: 12)
        {
            HStack
            {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.blue)
                    .font(.headline)

                Text("Key Metrics")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
            ], spacing: 12)
            {
                MetricCard(
                    emoji: "⏱️",
                    value: manager.calculateAveragePace(for: swim),
                    label: "Average Pace",
                    subtitle: "per 100m"
                )

                MetricCard(
                    emoji: "📏",
                    value: formatPoolLength(),
                    label: "Pool Length",
                    subtitle: "configured"
                )

                MetricCard(
                    emoji: "🔄",
                    value: "\(swim.laps.count)",
                    label: "Total Laps",
                    subtitle: "completed"
                )

                MetricCard(
                    emoji: "🎯",
                    value: manager.averageSwolfScore(for: swim),
                    label: "Avg SWOLF",
                    subtitle: "efficiency"
                )
            }
        }
    }

    private func formatPoolLength() -> String
    {
        guard let poolLength = swim.poolLength else { return "N/A" }
        let unit = swim.poolUnit ?? .meters
        return String(format: "%.0f %@", poolLength, unit.abbreviation)
    }
}

#Preview
{
    let baseDate = Date()
    let sampleLaps = [
        Lap(startDate: baseDate, endDate: baseDate.addingTimeInterval(45.2), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(startDate: baseDate.addingTimeInterval(60), endDate: baseDate.addingTimeInterval(102.1), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(startDate: baseDate.addingTimeInterval(120), endDate: baseDate.addingTimeInterval(164.7), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(startDate: baseDate.addingTimeInterval(180), endDate: baseDate.addingTimeInterval(223.8), metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(startDate: baseDate.addingTimeInterval(300), endDate: baseDate.addingTimeInterval(346.3), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 30.5]),
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

    return VStack
    {
        KeyMetricsGrid(swim: sampleSwim)
            .environmentObject(Manager())
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
