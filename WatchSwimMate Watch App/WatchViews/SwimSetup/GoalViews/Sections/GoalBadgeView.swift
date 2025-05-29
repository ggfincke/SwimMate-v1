// GoalBadgeView.swift

import SwiftUI

struct GoalBadgeView: View
{
    @Environment(WatchManager.self) private var manager
    let type: GoalType
    
    var body: some View
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
