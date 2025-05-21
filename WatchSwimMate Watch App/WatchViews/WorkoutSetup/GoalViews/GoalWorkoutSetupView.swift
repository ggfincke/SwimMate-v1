// GoalWorkoutSetupView

import SwiftUI

struct GoalWorkoutSetupView: View {
    @EnvironmentObject var manager: WatchManager
    @State private var showDistanceSetupSheet = false
    @State private var showTimeSetupSheet = false
    @State private var showCalorieSetupSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Set Your Goal")
                    .font(.headline)
                
                // distance goal
                ActionButton(
                    label: "Distance",
                    icon: "figure.pool.swim",
                    tint: .blue
                )
                {
                    showDistanceSetupSheet = true
                }

                // time goal
                ActionButton(
                    label: "Time",
                    icon: "clock.arrow.circlepath",
                    tint: .red
                )
                {
                    showTimeSetupSheet = true
                }

                // calorie goal
                ActionButton(
                    label: "Calories",
                    icon: "flame.fill",
                    tint: .orange
                )
                {
                    showCalorieSetupSheet = true
                }

                // open workout (no goal)
                ActionButton(
                    label: "Open",
                    icon: "play.circle.fill",
                    tint: .green
                ) {
                    manager.path.append(NavState.workoutSetup)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationTitle("Goal Setup")
        // sheets for goal setup (temporary; needs to go further in Navstack) 
        .sheet(isPresented: $showDistanceSetupSheet) {
            DistanceSetupView().environmentObject(manager)
        }
        .sheet(isPresented: $showTimeSetupSheet) {
            TimeSetupView().environmentObject(manager)
        }
        .sheet(isPresented: $showCalorieSetupSheet) {
            CalorieSetupView().environmentObject(manager)
        }
    }
    
    // check if any goals are active
    private var hasActiveGoals: Bool {
        return manager.goalDistance > 0 || manager.goalTime > 0 || manager.goalCalories > 0
    }
}

#Preview {
    GoalWorkoutSetupView()
        .environmentObject(WatchManager())
}
