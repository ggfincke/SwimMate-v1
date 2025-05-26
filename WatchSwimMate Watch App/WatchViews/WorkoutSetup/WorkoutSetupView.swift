// WorkoutSetupView.swift

import SwiftUI

struct WorkoutSetupView: View {
    @EnvironmentObject var manager: WatchManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Swim Type")
                .font(.headline)
                .padding(.top, 8)
            
            // pool swim
            ActionButton(
                label: "Pool",
                icon: "figure.pool.swim",
                tint: .blue
            ) {
                manager.isPool = true
                manager.path.append(NavState.indoorPoolSetup)
            }
            
            // open water swim
            ActionButton(
                label: "Open Water",
                icon: "water.waves",
                tint: .teal
            ) {
                manager.isPool = false
                // start workout immediately for open water
                manager.startWorkout()
                manager.path.append(NavState.swimmingView(set: nil))
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("Workout")
    }
}

#Preview {
    WorkoutSetupView()
        .environmentObject(WatchManager())
}
