// SwimMate/iOSViews/HomeView/Sections/WeeklyStatsSection.swift

import SwiftUI

struct WeeklyStatsSection: View
{
    @EnvironmentObject var manager: Manager

    var body: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            Text("This Week")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            HStack(spacing: 12)
            {
                StatCard(
                    title: "Workouts",
                    value: "\(manager.weeklyStats().workouts)",
                    icon: "figure.pool.swim",
                    color: .blue,
                    trend: trendFromString(manager.weeklyWorkoutTrend())
                )

                StatCard(
                    title: "Distance",
                    value: String(format: "%.0f", manager.weeklyStats().distance),
                    icon: "ruler",
                    color: .green,
                    trend: trendFromString(manager.weeklyDistanceTrend())
                )

                StatCard(
                    title: "Time",
                    value: "\(Int(manager.weeklyStats().time / 60))m",
                    icon: "clock",
                    color: .orange,
                    trend: trendFromString(manager.weeklyTimeTrend())
                )
            }
        }
    }

    private func trendFromString(_ trendString: String) -> StatTrend
    {
        switch trendString
        {
        case "up":
            return .up
        case "down":
            return .down
        default:
            return .neutral
        }
    }
}

#Preview
{
    WeeklyStatsSection()
        .environmentObject(Manager())
}
