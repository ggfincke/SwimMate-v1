// CalorieSetupView.swift

import SwiftUI

struct CalorieSetupView: View

{

    @Environment(WatchManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    // quick select for calories
    private let caloriePresets = [100, 200, 300, 500, 750, 1000]

    // defining binding
    var body: some View
    {
        return GoalSetupView(
        title: "Calorie Goal",
        unit: "kcal",
        accentColor: .orange,
        presetValues: caloriePresets,
        minValue: 0,
        maxValue: WatchManager.maxCalorieGoal,
        value: Binding(
        get: { manager.goalCalories },
        set: { manager.goalCalories = $0 }
        ),
        onDismiss:
        {
            dismiss()
        }
        )
    }
}

#Preview
{
    CalorieSetupView()
    .environment(WatchManager())
}
