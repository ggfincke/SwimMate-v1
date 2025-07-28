// GoalSetupButtonsSection.swift

import SwiftUI

struct GoalSetupButtonsSection: View

{
    @Environment(WatchManager.self) private var manager
    @Binding var showDistanceSetupSheet: Bool
    @Binding var showTimeSetupSheet: Bool
    @Binding var showCalorieSetupSheet: Bool

    let isCompactDevice = WKInterfaceDevice.current().screenBounds.height <= 200

    var body: some View
    {
        VStack(spacing: 10)
        {
            // distance goal
            ActionButton(
                label: "Distance",
                icon: manager.getIcon(for: .distance),
                tint: manager.getColor(for: .distance),
                compact: isCompactDevice
            )
            {
                showDistanceSetupSheet = true
            }

            // time goal
            ActionButton(
                label: "Time",
                icon: "clock.arrow.circlepath",
                tint: .purple,
                compact: isCompactDevice
            )
            {
                showTimeSetupSheet = true
            }

            // calorie goal
            ActionButton(
                label: "Calories",
                icon: manager.getIcon(for: .calories),
                tint: manager.getColor(for: .calories),
                compact: isCompactDevice
            )
            {
                showCalorieSetupSheet = true
            }
        }
    }
}
