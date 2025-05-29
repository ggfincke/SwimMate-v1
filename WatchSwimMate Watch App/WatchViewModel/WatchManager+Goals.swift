// WatchManager+Goals.swift

// Goal Management Extension

import Foundation
import SwiftUI
import WatchKit

// MARK: - Goal Management
extension WatchManager 
{
    // check if any goals are currently active
    var hasActiveGoals: Bool 
    {
        return goalDistance > 0 || goalTime > 0 || goalCalories > 0
    }
    
    // check if a specific goal type is set
    func hasGoal(_ type: GoalType) -> Bool 
    {
        switch type 
        {
            case .distance: return goalDistance > 0
            case .time: return goalTime > 0
            case .calories: return goalCalories > 0
        }
    }
    
    // clear all goals
    func clearAllGoals() 
    {
        WKInterfaceDevice.current().play(.click)
        goalDistance = 0
        goalTime = 0
        goalCalories = 0
        
        // reset goal unit lock when clearing all goals
        goalUnitLocked = false
    }
    
    // format time interval for display
    func formatTime(_ time: TimeInterval) -> String 
    {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        if hours > 0 {
            return String(format: "%d:%02d", hours, minutes)
        } else {
            return "\(minutes)m"
        }
    }
    
    // get goal progress for a specific goal type (0.0 to 1.0+)
    func getGoalProgress(for type: GoalType) -> Double 
    {
        switch type 
        {
        case .distance:
            guard goalDistance > 0 else { return 0.0 }
            return distance / goalDistance
        case .time:
            guard goalTime > 0 else { return 0.0 }
            return elapsedTime / goalTime
        case .calories:
            guard goalCalories > 0 else { return 0.0 }
            return activeEnergy / goalCalories
        }
    }
    
    // check if a specific goal has been achieved
    func isGoalAchieved(_ type: GoalType) -> Bool 
    {
        return getGoalProgress(for: type) >= 1.0
    }
    
    // get the current value for a goal type
    func getCurrentValue(for type: GoalType) -> Double 
    {
        switch type 
        {
            case .distance: return distance
            case .time: return elapsedTime
            case .calories: return activeEnergy
        }
    }
    
    // get the target value for a goal type
    func getTargetValue(for type: GoalType) -> Double 
    {
        switch type 
        {
            case .distance: return goalDistance
            case .time: return goalTime
            case .calories: return goalCalories
        }
    }
    
    // get the unit string for a goal type
    func getUnit(for type: GoalType) -> String 
    {
        switch type 
        {
            case .distance: return goalUnit == "meters" ? "m" : "yd"
            case .time: return ""
            case .calories: return "kcal"
        }
    }
    
    // get the icon for a goal type
    func getIcon(for type: GoalType) -> String 
    {
        switch type 
        {
            case .distance: return "figure.pool.swim"
            case .time: return "clock.fill"
            case .calories: return "flame.fill"
        }
    }
    
    // get the color for a goal type
    func getColor(for type: GoalType) -> Color 
    {
        switch type 
        {
            case .distance: return .blue
            case .time: return .red
            case .calories: return .orange
        }
    }
} 