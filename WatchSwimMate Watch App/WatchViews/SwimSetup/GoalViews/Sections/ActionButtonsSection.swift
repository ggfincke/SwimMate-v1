// ActionButtonsSection.swift

import SwiftUI

struct ActionButtonsSection: View

{

    @Environment(WatchManager.self) private var manager

    var body: some View
    {
        VStack(spacing: 10)
        {
            // start workout button
            ActionButton(
            label: "Start",
            icon: "play.fill",
            tint: .green,
            compact: manager.isCompactDevice,
            showArrow: true
            )
            {
                manager.path.append(NavState.swimSetup)
            }

            // clear goals button (if any goals are set)
            if manager.hasActiveGoals
            {
                ActionButton(
                label: "Clear All",
                icon: "trash",
                tint: .red,
                compact: manager.isCompactDevice
                )
                {
                    manager.clearAllGoals()
                }
            }
        }
    }
}
