// KeyMetricsSection.swift

import SwiftUI

// Key Metrics Section
struct KeyMetricsSection: View

{

    @Environment(WatchManager.self) private var manager

    private var durationFormatter: DateComponentsFormatter =
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
        }()

        // responsive grid spacing
        private var gridSpacing: CGFloat
        {
            manager.isCompactDevice ? 10 : 12
        }

        var body: some View
        {
            VStack(spacing: gridSpacing)
            {
                // section header
                HStack
                {
                    Text("WORKOUT SUMMARY")
                    .font(.system(size: manager.isCompactDevice ? 9 : 10, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(0.5)

                    Spacer()
                }

                // metrics grid
                LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
                ], spacing: gridSpacing)
                {
                    // duration
                    WatchMetricCard(
                    title: "Total Time",
                    value: durationFormatter.string(from: workoutDuration) ?? "40:00",
                    unit: "",
                    color: .yellow,
                    icon: "clock.fill",
                    isCompact: manager.isCompactDevice
                    )

                    // distance
                    WatchMetricCard(
                    title: "Distance",
                    value: formatDistance(),
                    unit: manager.poolUnit == "meters" ? "m" : "yd",
                    color: .green,
                    icon: "figure.pool.swim",
                    isCompact: manager.isCompactDevice
                    )

                    // energy
                    WatchMetricCard(
                    title: "Calories",
                    value: "\(Int(totalCalories))",
                    unit: "kcal",
                    color: .pink,
                    icon: "flame.fill",
                    isCompact: manager.isCompactDevice
                    )

                    // heart rate
                    WatchMetricCard(
                    title: "Avg HR",
                    value: "\(Int(averageHeartRate))",
                    unit: "bpm",
                    color: .red,
                    icon: "heart.fill",
                    isCompact: manager.isCompactDevice
                    )
                }
            }
        }

        // properties that fallback
        private var workoutDuration: TimeInterval
        {
            return manager.workout?.duration ?? manager.elapsedTime
        }

        private var totalDistance: Double
        {
            return manager.workout?.totalDistance?.doubleValue(for: .meter()) ?? manager.distance
        }

        private var totalCalories: Double
        {
            return manager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? manager.activeEnergy
        }

        private var averageHeartRate: Double
        {
            return manager.averageHeartRate > 0 ? manager.averageHeartRate : manager.heartRate
        }

        private func formatDistance() -> String
        {
            let distance = totalDistance

            if manager.poolUnit == "yards"
            {
                let yards = distance * 1.09361
                return "\(Int(yards))"
            }
            else
            {
                return "\(Int(distance))"
            }
        }
    }

    // preview
    #Preview("Standard Size")
    {
        KeyMetricsSection()
        .environment({
            let manager = WatchManager()
            manager.distance = 750
            manager.elapsedTime = 1234.56
            manager.heartRate = 142
            manager.activeEnergy = 285
            manager.averageHeartRate = 138
            return manager
            }())
        }

        #Preview("Compact Size")
        {
            KeyMetricsSection()
            .environment({
                let manager = WatchManager()
                manager.distance = 750
                manager.elapsedTime = 1234.56
                manager.heartRate = 142
                manager.activeEnergy = 285
                manager.averageHeartRate = 138
                return manager
                }())
            }
