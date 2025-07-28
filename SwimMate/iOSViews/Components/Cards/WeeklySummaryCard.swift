// SwimMate/iOSViews/Components/Cards/WeeklySummaryCard.swift

import SwiftUI

// weekly summary card
struct WeeklySummaryCard: View
{
    @EnvironmentObject var manager: Manager

    var body: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            Text("Weekly Summary")
                .font(.headline)

            HStack(spacing: 20)
            {
                SummaryMetricItem(
                    emoji: "🔥",
                    value: "\(weeklyStats.workoutCount)",
                    label: "Workouts"
                )

                SummaryMetricItem(
                    emoji: "⏱️",
                    value: "\(weeklyStats.totalMinutes)",
                    label: "Minutes"
                )

                SummaryMetricItem(
                    emoji: "🌊",
                    value: weeklyStats.formattedDistance,
                    label: "Distance"
                )
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }

    private var weeklyStats: (workoutCount: Int, totalMinutes: Int, formattedDistance: String)
    {
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let weeklySwims = manager.swims.filter { $0.date >= lastWeekDate }
        let totalWorkouts = weeklySwims.count
        let totalMinutes = weeklySwims.reduce(0) { $0 + Int($1.duration / 60) }
        let totalDistance = weeklySwims.compactMap { $0.totalDistance }.reduce(0, +)

        return (totalWorkouts, totalMinutes, manager.formatDistance(totalDistance))
    }
}

#Preview
{
    WeeklySummaryCard()
        .environmentObject(Manager())
}
