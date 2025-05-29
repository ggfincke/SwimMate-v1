// DistanceSetupView.swift

import SwiftUI

struct DistanceSetupView: View
{
    @Environment(WatchManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    
    // quick selects for distance
    private let distancePresets = [100, 250, 500, 1000, 2000]
    
    var body: some View
    {
        // defining binding
        let distanceBinding = Binding(
            get: { manager.goalDistance },
            set: { manager.goalDistance = $0 }
        )
        
        return GoalSetupView(
            title: "Distance Goal",
            unit: manager.poolUnit,
            accentColor: .blue,
            presetValues: distancePresets,
            minValue: 0,
            maxValue: 5000,
            stepValue: 25,
            sensitivity: .medium,
            value: distanceBinding,
            onDismiss: 
            {
                // nav to swim setup after setting goal
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    manager.path.append(NavState.swimSetup)
                }
            }
        )
    }
}

#Preview {
    DistanceSetupView()
        .environment(WatchManager())
}
