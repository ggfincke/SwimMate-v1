// CurrentGoalsDisplaySection.swift

import SwiftUI

struct CurrentGoalsDisplaySection: View
{
    @Environment(WatchManager.self) private var manager
    
    var body: some View
    {
        if manager.hasActiveGoals
        {
            VStack(spacing: 8)
            {
                Text("Current Goals")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                let activeGoals = getActiveGoals()
                
                VStack(spacing: 8)
                {
                    // 1st row - first two active badges
                    if activeGoals.count >= 1
                    {
                        HStack(spacing: 12)
                        {
                            GoalBadgeView(type: activeGoals[0])
                            
                            if activeGoals.count >= 2
                            {
                                GoalBadgeView(type: activeGoals[1])
                            }
                        }
                    }
                    
                    // 2nd row - third badge centered (if exists)
                    if activeGoals.count >= 3
                    {
                        HStack
                        {
                            Spacer()
                            GoalBadgeView(type: activeGoals[2])
                            Spacer()
                        }
                    }
                }
            }
            .padding(.bottom, 8)
        }
    }
    
    private func getActiveGoals() -> [GoalType]
    {
        var goals: [GoalType] = []
        
        if manager.hasGoal(.distance) { goals.append(.distance) }
        if manager.hasGoal(.time) { goals.append(.time) }
        if manager.hasGoal(.calories) { goals.append(.calories) }
        
        return goals
    }
}

#Preview("Single Goal")
{
    let manager = WatchManager()
    manager.goalDistance = 1000
    
    return CurrentGoalsDisplaySection()
        .environment(manager)
}

#Preview("Two Goals")
{
    let manager = WatchManager()
    manager.goalDistance = 1000
    manager.goalTime = 1800
    
    return CurrentGoalsDisplaySection()
        .environment(manager)
}

#Preview("All Three Goals")
{
    let manager = WatchManager()
    manager.goalDistance = 1000
    manager.goalTime = 1800
    manager.goalCalories = 300
    
    return CurrentGoalsDisplaySection()
        .environment(manager)
} 
