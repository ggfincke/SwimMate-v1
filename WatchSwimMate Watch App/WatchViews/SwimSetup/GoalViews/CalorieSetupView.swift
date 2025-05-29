// CalorieSetupView.swift

import SwiftUI

struct CalorieSetupView: View
{
    @Bindable var manager: WatchManager
    @Environment(\.dismiss) private var dismiss
    
    // quick select for calories
    private let caloriePresets = [100, 200, 300, 500, 750]
    
    // defining binding
    var body: some View
    {
        return GoalSetupView(
            title: "Calorie Goal",
            unit: "kcal",
            accentColor: .orange,
            presetValues: caloriePresets,
            minValue: 0,
            maxValue: 2000,
            stepValue: 5,
            sensitivity: .medium,
            value: $manager.goalCalories,
            onDismiss:
                {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                {
                    manager.path.append(NavState.swimSetup)
                }
            }
        )
    }
}

#Preview
{
    CalorieSetupView(manager: WatchManager())
}
