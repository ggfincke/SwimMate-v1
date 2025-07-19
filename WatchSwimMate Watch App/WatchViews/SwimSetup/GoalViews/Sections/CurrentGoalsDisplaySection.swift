// CurrentGoalsDisplaySection.swift

import SwiftUI

struct CurrentGoalsDisplaySection: View

{

    @Environment(WatchManager.self) private var manager

    var body: some View
    {
        if manager.hasActiveGoals
        {
            VStack(spacing: manager.isCompactDevice ? 4 : 8)
            {
                Text("Current Goals")
                .font(.system(size: manager.isCompactDevice ? 10 : 12, weight: .medium))
                .foregroundColor(.secondary)

                let activeGoals = getActiveGoals()

                if manager.isCompactDevice
                {
                    // vertical stack for compact devices
                    VStack(spacing: 3)
                    {
                        ForEach(activeGoals, id: \.self)
                        {
                            goalType in
                            CompactGoalBadgeView(type: goalType)
                        }
                    }
                }
                else
                {
                    // original layout
                    VStack(spacing: 8)
                    {
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
            }
            .padding(.bottom, manager.isCompactDevice ? 6 : 8)
        }
    }

    private func getActiveGoals() -> [GoalType]
    {
        var goals: [GoalType] = []
        if manager.hasGoal(.distance)
        {
            goals.append(.distance) }
            if manager.hasGoal(.time)
            {
                goals.append(.time) }
                if manager.hasGoal(.calories)
                {
                    goals.append(.calories) }
                    return goals
                }
            }



            #Preview("Compact Device - Multiple Goals")
            {
                let manager = WatchManager()
                manager.goalDistance = 1000
                manager.goalTime = 1800
                manager.goalCalories = 300
                manager.goalUnit = "meters"

                return CurrentGoalsDisplaySection()
                .environment(manager)
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
