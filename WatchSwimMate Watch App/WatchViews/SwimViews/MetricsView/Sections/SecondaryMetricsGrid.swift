// SecondaryMetricsGrid.swift

import SwiftUI

// secondary metrics
struct SecondaryMetricsGrid: View

{
    @Environment(WatchManager.self) private var manager

    // responsive grid spacing
    private var gridSpacing: CGFloat
    {
        manager.isCompactDevice ? 6 : 8
    }

    var body: some View
    {
        // grid
        VStack(spacing: gridSpacing)
        {
            // first row (laps & HR)
            HStack(spacing: gridSpacing)
            {
                WatchMetricCard(
                    title: "Laps",
                    value: "\(manager.laps)",
                    unit: "laps",
                    color: .green,
                    icon: "arrow.clockwise",
                    isCompact: manager.isCompactDevice
                )

                WatchMetricCard(
                    title: "Heart Rate",
                    value: "\(Int(manager.heartRate))",
                    unit: "bpm",
                    color: .red,
                    icon: "heart.fill",
                    isCompact: manager.isCompactDevice
                )
            }

            // second row (calories & per 100 pace)
            HStack(spacing: gridSpacing)
            {
                WatchMetricCard(
                    title: "Calories",
                    value: "\(Int(manager.activeEnergy))",
                    unit: "kcal",
                    color: .orange,
                    icon: "flame.fill",
                    isCompact: manager.isCompactDevice
                )

                WatchMetricCard(
                    title: "Pace",
                    value: currentPace,
                    unit: "/100\(manager.poolUnit == "meters" ? "m" : "yd")",
                    color: .purple,
                    icon: "speedometer",
                    isCompact: manager.isCompactDevice
                )
            }
        }
    }

    // pace calculation using manager's elapsedTime
    private var currentPace: String
    {
        let elapsedTime = manager.elapsedTime
        guard manager.distance > 0 && elapsedTime > 0
        else
        {
            return "--:--"
        }

        let distanceIn100Units = manager.distance / (manager.poolUnit == "meters" ? 100 : 109.361)
        let paceSeconds = elapsedTime / distanceIn100Units

        let minutes = Int(paceSeconds) / 60
        let seconds = Int(paceSeconds) % 60

        return String(format: "%d:%02d", minutes, seconds)
    }
}

// preview
#Preview("Standard Size")
{
    SecondaryMetricsGrid()
        .environment({
            let manager = WatchManager()
            manager.distance = 750
            manager.elapsedTime = 1234.56
            manager.heartRate = 142
            manager.activeEnergy = 285
            manager.laps = 15
            return manager
        }())
}

#Preview("Compact Size")
{
    SecondaryMetricsGrid()
        .environment({
            let manager = WatchManager()
            manager.distance = 750
            manager.elapsedTime = 1234.56
            manager.heartRate = 142
            manager.activeEnergy = 285
            manager.laps = 15
            return manager
        }())
}
