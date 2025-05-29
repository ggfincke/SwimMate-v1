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
        VStack(spacing: 16) 
        {
            if manager.hasGoal(.distance) 
            {
                goalProgressCard(for: .distance)
            }
            
            if manager.hasGoal(.time) 
            {
                goalProgressCard(for: .time)
            }
            
            if manager.hasGoal(.calories) 
            {
                goalProgressCard(for: .calories)
            }
        }
    }
    
    // MARK: - Goal Progress Card Builder
    private func goalProgressCard(for type: GoalType) -> some View 
    {
        let title: String
        switch type 
        {
            case .distance: title = "Distance Goal"
            case .time: title = "Time Goal"
            case .calories: title = "Calorie Goal"
        }
        
        return GoalProgressCard(
            title: title,
            progress: manager.getCurrentValue(for: type),
            total: manager.getTargetValue(for: type),
            unit: manager.getUnit(for: type),
            color: manager.getColor(for: type),
            isTimeFormat: type == .time,
            formatTime: manager.formatTime
        )
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
    let formatTime: (TimeInterval) -> String
    
    private var progressPercentage: Double
    {
        guard total > 0 else { return 0 }
        return min(progress / total, 1.0)
    }
    
    var body: some View 
    {
        VStack(spacing: 8) 
        {
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
        if isTimeFormat 
        {
            return "\(formatTime(progress)) / \(formatTime(total))"
        } 
        else 
        {
            return "\(Int(progress)) / \(Int(total)) \(unit)"
        }
    }
}

// preview
#Preview 
{
    GoalProgressView()
        .environmentObject(WatchManager())
}
