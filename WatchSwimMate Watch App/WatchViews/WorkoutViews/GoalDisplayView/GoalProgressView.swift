// GoalProgressView.swift

import SwiftUI

// goal progress
struct GoalProgressView: View
{
    @EnvironmentObject var manager: WatchManager

    var body: some View
    {
        VStack(spacing: 20)
        {
            headerView
            goalsList
        }
        .padding()
    }
    
    // MARK: - Header View
    private var headerView: some View
    {
        Text("Goal Progress")
            .font(.headline)
    }
    
    // MARK: - Goals List
    private var goalsList: some View
    {
        VStack(spacing: 16) {
            distanceGoalView
            timeGoalView
            caloriesGoalView
        }
    }
    
    // MARK: - Distance Goal
    @ViewBuilder
    private var distanceGoalView: some View
    {
        if manager.goalDistance > 0
        {
            GoalProgressCard(
                title: "Distance Goal",
                progress: manager.distance,
                total: manager.goalDistance,
                unit: manager.poolUnit == "meters" ? "m" : "yd",
                color: .blue
            )
        }
    }
    
    // MARK: - Time Goal
    @ViewBuilder
    private var timeGoalView: some View
    {
        if manager.goalTime > 0
        {
            GoalProgressCard(
                title: "Time Goal",
                progress: manager.elapsedTime,
                total: manager.goalTime,
                unit: "time",
                color: .green,
                isTimeFormat: true
            )
        }
    }
    
    // MARK: - Calories Goal
    @ViewBuilder
    private var caloriesGoalView: some View
    {
        if manager.goalCalories > 0
        {
            GoalProgressCard(
                title: "Calorie Goal",
                progress: manager.activeEnergy,
                total: manager.goalCalories,
                unit: "kcal",
                color: .red
            )
        }
    }
}

// MARK: Goal Progress Card
struct GoalProgressCard: View
{
    let title: String
    let progress: Double
    let total: Double
    let unit: String
    let color: Color
    var isTimeFormat: Bool = false
    
    private var progressPercentage: Double
    {
        guard total > 0 else { return 0 }
        return min(progress / total, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            titleView
            progressBarView
            progressTextView
        }
    }
    
    // title view
    private var titleView: some View
    {
        Text(title)
            .font(.subheadline)
            .fontWeight(.medium)
    }
    
    // progress bar view
    private var progressBarView: some View
    {
        ProgressView(value: progressPercentage)
            .progressViewStyle(
                LinearProgressViewStyle(tint: color)
            )
    }
    
    // progress text view
    private var progressTextView: some View
    {
        Text(formatProgressText())
            .font(.subheadline)
    }
    
    // MARK: helper methods
    private func formatProgressText() -> String
    {
        if isTimeFormat {
            return "\(formatTime(progress)) / \(formatTime(total))"
        } else {
            return "\(Int(progress)) / \(Int(total)) \(unit)"
        }
    }
    
    // formatting time
    private func formatTime(_ time: TimeInterval) -> String
    {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}

// preview
#Preview {
    GoalProgressView()
        .environmentObject(WatchManager())
}
