// DistanceSetupView.swift

import SwiftUI

struct DistanceSetupView: View

{
    @Environment(WatchManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    // quick selects for distance
    private let distancePresets = [100, 250, 500, 1000, 2500, 5000]

    var body: some View
    {
        GoalSetupView(
            title: "Distance Goal",
            unit: manager.goalUnit == "meters" ? "m" : "yd",
            accentColor: .blue,
            presetValues: distancePresets,
            minValue: 0,
            maxValue: WatchManager.maxDistanceGoal,
            value: Binding(
                get: { manager.goalDistance },
                set: { manager.goalDistance = $0 }
            ),
            availableUnits: ["meters", "yards"],
            selectedUnit: Binding(
                get: { manager.goalUnit },
                set: { manager.goalUnit = $0 }
            ),
            onUnitChange:
            {
                newUnit in
                manager.goalUnit = newUnit
            },
            onDismiss:
            {
                // lock the goal unit once set
                manager.goalUnitLocked = true
                dismiss()
            }
        )
    }
}

#Preview
{
    DistanceSetupView()
        .environment(WatchManager())
}
