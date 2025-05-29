// GoalProgressList.swift

import SwiftUI

struct GoalProgressList: View 
{
    @Environment(WatchManager.self) private var manager
    
    var body: some View 
    {
        VStack(spacing: 4)
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
        return GoalProgressCard(
            type: type,
            progress: manager.getCurrentValue(for: type),
            total: manager.getTargetValue(for: type),
            unit: manager.getUnit(for: type),
            color: manager.getColor(for: type),
            icon: manager.getIcon(for: type),
            isTimeFormat: type == .time,
            formatTime: manager.formatTime,
            isCompact: manager.isCompactDevice
        )
    }
}

#Preview("Single Goal") 
{
    let manager = WatchManager()
    manager.goalDistance = 1000
    manager.distance = 650
    manager.goalUnit = "meters"
    
    return GoalProgressList()
        .environment(manager)
}

#Preview("Multiple Goals") 
{
    let manager = WatchManager()
    manager.goalDistance = 1500
    manager.distance = 900
    manager.goalTime = 1800
    manager.elapsedTime = 1200
    manager.goalCalories = 400
    manager.activeEnergy = 280
    manager.goalUnit = "meters"
    
    return GoalProgressList()
        .environment(manager)
} 