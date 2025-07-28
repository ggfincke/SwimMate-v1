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

// compact badge view for small screens
struct CompactGoalBadgeView: View
{
    @Environment(WatchManager.self) private var manager
    let type: GoalType

    var body: some View
    {
        let (value, unit) = getValueAndUnit()

        return HStack(spacing: 3)
        {
            Image(systemName: manager.getIcon(for: type))
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(manager.getColor(for: type))
                .frame(width: 12)

            Text(value)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.primary)

            if !unit.isEmpty
            {
                Text(unit)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(manager.getColor(for: type).opacity(0.1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }

    private func getValueAndUnit() -> (String, String)
    {
        switch type
        {
        case .distance:
            let unit = manager.goalUnit == "meters" ? "m" : "yd"
            return ("\(Int(manager.goalDistance))", unit)
        case .time:
            let totalMinutes = Int(manager.goalTime) / 60
            let hours = totalMinutes / 60
            let minutes = totalMinutes % 60

            if hours > 0
            {
                return ("\(hours):\(String(format: "%02d", minutes))", "")
            }
            else
            {
                return ("\(minutes)", "min")
            }
        case .calories:
            return ("\(Int(manager.goalCalories))", "cal")
        }
    }
}
