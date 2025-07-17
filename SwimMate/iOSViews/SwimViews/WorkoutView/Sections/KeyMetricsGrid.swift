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
                GridItem(.flexible())
            ], spacing: 12)
            {
                SimpleMetricCard(
                    emoji: "⏱️",
                    value: calculateAveragePace(),
                    label: "Average Pace",
                    subtitle: "per 100m"
                )
                
                SimpleMetricCard(
                    emoji: "📏",
                    value: formatPoolLength(),
                    label: "Pool Length",
                    subtitle: "configured"
                )
                
                SimpleMetricCard(
                    emoji: "🔄",
                    value: "\(swim.laps.count)",
                    label: "Total Laps",
                    subtitle: "completed"
                )
                
                SimpleMetricCard(
                    emoji: "🎯",
                    value: String(format: "%.1f", averageSwolfScore()),
                    label: "Avg SWOLF",
                    subtitle: "efficiency"
                )
            }
        }
    }
    
    private func calculateAveragePace() -> String
    {
        guard let distance = swim.totalDistance, distance > 0 else { return "N/A" }
        let paceSeconds = swim.duration / (distance / 100)
        let minutes = Int(paceSeconds) / 60
        let seconds = Int(paceSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func formatPoolLength() -> String
    {
        guard let poolLength = swim.poolLength else { return "N/A" }
        return String(format: "%.0f m", poolLength)
    }
    
    private func averageSwolfScore() -> Double
    {
        let validScores = swim.laps.compactMap { $0.swolfScore }
        return validScores.isEmpty ? 0 : validScores.reduce(0, +) / Double(validScores.count)
    }
}

#Preview
{
    let sampleLaps = [
        Lap(duration: 45.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(duration: 42.1, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(duration: 44.7, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(duration: 43.8, metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(duration: 46.3, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 30.5])
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
        KeyMetricsGrid(swim: sampleSwim)
            .environmentObject(Manager())
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
