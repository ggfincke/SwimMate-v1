// CalorieSetupView.swift

import SwiftUI

struct CalorieSetupView: View
{
    @EnvironmentObject var manager: WatchManager
    @Environment(\.dismiss) private var dismiss
    
    // quick select for calories
    private let caloriePresets = [100, 200, 300, 500, 750]
    
    var body: some View
    {
        GoalSetupView(
            title: "Calorie Goal",
            unit: "kcal",
            accentColor: .orange,
            presetValues: caloriePresets,
            minValue: 0,
            maxValue: 2000,
            stepValue: 5,
            sensitivity: .medium,
            value: $manager.goalCalories,
            onDismiss: {
                dismiss()
            }
        )
    }
}

#Preview
{
    CalorieSetupView()
        .environmentObject(WatchManager())
}
