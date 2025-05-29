// GoalProgressView.swift

import SwiftUI

// goal progress
struct GoalProgressView: View
{
    @Environment(WatchManager.self) private var manager

    var body: some View
    {
        VStack(spacing: manager.isCompactDevice ? 2 : 2)
        {
            // show header if space
            if (manager.goalCount < 3 && !(manager.isCompactDevice))
            {
                GoalProgressHeader()
            }
            GoalProgressList()
        }
    }
}

// preview
#Preview("No Goals")
{
    let manager = WatchManager()
    
    return GoalProgressView()
        .environment(manager)
}

#Preview("Distance Goal Only") 
{
    let manager = WatchManager()
    manager.goalDistance = 1000
    manager.distance = 650  // 65% progress
    manager.goalUnit = "meters"
    
    return GoalProgressView()
        .environment(manager)
}

#Preview("Two Goals - Distance & Time")
{
    let manager = WatchManager()
    manager.goalDistance = 1500
    manager.distance = 900  // 60% progress
    manager.goalTime = 1800  // 30 minutes
    manager.elapsedTime = 1200  // 20 minutes (67% progress)
    manager.goalUnit = "meters"
    
    return GoalProgressView()
        .environment(manager)
}

#Preview("All Three Goals") 
{
    let manager = WatchManager()
    manager.goalDistance = 2000
    manager.distance = 1800  // 90% progress
    manager.goalTime = 2400  // 40 minutes
    manager.elapsedTime = 1680  // 28 minutes (70% progress)
    manager.goalCalories = 500
    manager.activeEnergy = 350  // 70% progress
    manager.goalUnit = "meters"
    
    return GoalProgressView()
        .environment(manager)
}

#Preview("Goals Exceeded")
{
    let manager = WatchManager()
    manager.goalDistance = 1000
    manager.distance = 1200  // 120% progress
    manager.goalTime = 1800  // 30 minutes
    manager.elapsedTime = 2100  // 35 minutes (117% progress)
    manager.goalCalories = 400
    manager.activeEnergy = 450  // 113% progress
    manager.goalUnit = "meters"
    
    return GoalProgressView()
        .environment(manager)
}
