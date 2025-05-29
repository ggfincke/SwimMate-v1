// ActionButtonsSection.swift

import SwiftUI

struct ActionButtonsSection: View
{
    @Environment(WatchManager.self) private var manager
    
    let isCompactDevice = WKInterfaceDevice.current().screenBounds.height <= 200
    
    var body: some View
    {
        VStack(spacing: 10)
        {
            // start workout button
            ActionButton(
                label: "Start Workout",
                icon: "play.fill",
                tint: .green,
                compact: isCompactDevice,
                showArrow: true
            )
            {
                manager.path.append(NavState.swimSetup)
            }
            
            // clear goals button (if any goals are set)
            if manager.hasActiveGoals
            {
                ActionButton(
                    label: "Clear All Goals",
                    icon: "trash",
                    tint: .red,
                    compact: isCompactDevice
                )
                {
                    manager.clearAllGoals()
                }
            }
        }
    }
} 
