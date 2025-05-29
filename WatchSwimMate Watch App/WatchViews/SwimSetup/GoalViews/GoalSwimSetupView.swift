// GoalSwimSetupView.swift

import SwiftUI

struct GoalSwimSetupView: View
{
    @Environment(WatchManager.self) private var manager
    @State private var showDistanceSetupSheet = false
    @State private var showTimeSetupSheet = false
    @State private var showCalorieSetupSheet = false
    let isCompactDevice = WKInterfaceDevice.current().screenBounds.height <= 200

    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 10)
            {
                Text("Set Your Goal")
                    .font(.headline)
                
                // show current goals (if any are set)
                if manager.hasActiveGoals 
                {
                    VStack(spacing: 8) 
                    {
                        Text("Current Goals")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) 
                        {
                            if manager.hasGoal(.distance) 
                            {
                                goalBadge(for: .distance)
                            }
                            
                            if manager.hasGoal(.time) 
                            {
                                goalBadge(for: .time)
                            }
                            
                            if manager.hasGoal(.calories) 
                            {
                                goalBadge(for: .calories)
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                
                // distance goal
                ActionButton(
                    label: manager.hasGoal(.distance) ? "Update Distance" : "Distance",
                    icon: manager.getIcon(for: .distance),
                    tint: manager.getColor(for: .distance),
                    compact: isCompactDevice
                )
                {
                    showDistanceSetupSheet = true
                }
                
                // time goal
                ActionButton(
                    label: manager.hasGoal(.time) ? "Update Time" : "Time",
                    icon: "clock.arrow.circlepath",
                    tint: manager.getColor(for: .time),
                    compact: isCompactDevice
                )
                {
                    showTimeSetupSheet = true
                }
                
                // calorie goal
                ActionButton(
                    label: manager.hasGoal(.calories) ? "Update Calories" : "Calories",
                    icon: manager.getIcon(for: .calories),
                    tint: manager.getColor(for: .calories),
                    compact: isCompactDevice
                )
                {
                    showCalorieSetupSheet = true
                }
                
                // start workout button (more prominent if goals are set)
                ActionButton(
                    label: manager.hasActiveGoals ? "Start with Goals" : "Start without Goal",
                    icon: manager.hasActiveGoals ? "target" : "play.circle.fill",
                    tint: manager.hasActiveGoals ? .green : .gray,
                    compact: isCompactDevice
                )
                {
                    manager.path.append(NavState.swimSetup)
                }
                
                // clear goals button (if any goals are set)
                if manager.hasActiveGoals 
                {
                    Button("Clear All Goals") 
                    {
                        manager.clearAllGoals()
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .navigationTitle("Goal Setup")
            // sheets for goal setup (distance, time, calories)
            .sheet(isPresented: $showDistanceSetupSheet) 
            {
                DistanceSetupView()
            }
            .sheet(isPresented: $showTimeSetupSheet) 
            {
                TimeSetupView()
            }
            .sheet(isPresented: $showCalorieSetupSheet) 
            {
                CalorieSetupView()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func goalBadge(for type: GoalType) -> some View 
    {
        let value: String
        
        switch type 
        {
        case .distance:
            value = "\(Int(manager.goalDistance))"
        case .time:
            value = manager.formatTime(manager.goalTime)
        case .calories:
            value = "\(Int(manager.goalCalories))"
        }
        
        return HStack(spacing: 4) 
        {
            Image(systemName: manager.getIcon(for: type))
                .font(.system(size: 10))
                .foregroundColor(manager.getColor(for: type))
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)
            let unit = manager.getUnit(for: type)
            if !unit.isEmpty 
            {
                Text(unit)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(manager.getColor(for: type).opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview 
{
    GoalSwimSetupView()
        .environment(WatchManager())
} 
