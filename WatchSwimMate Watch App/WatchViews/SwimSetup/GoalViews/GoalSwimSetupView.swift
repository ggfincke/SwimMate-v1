// GoalSwimSetupView.swift

import SwiftUI

struct GoalSwimSetupView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var showDistanceSetupSheet = false
    @State private var showTimeSetupSheet = false
    @State private var showCalorieSetupSheet = false
    let isCompactDevice = WKInterfaceDevice.current().screenBounds.height <= 200

    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 10)
            {
                Text("Set Your Goal")
                    .font(.headline)
                
                // distance goal
                ActionButton(
                    label: "Distance",
                    icon: "figure.pool.swim",
                    tint: .blue,
                    compact: isCompactDevice
                    
                )
                {
                    showDistanceSetupSheet = true
                }
                
                // time goal
                ActionButton(
                    label: "Time",
                    icon: "clock.arrow.circlepath",
                    tint: .red,
                    compact: isCompactDevice
                    
                )
                {
                    showTimeSetupSheet = true
                }
                
                // calorie goal
                ActionButton(
                    label: "Calories",
                    icon: "flame.fill",
                    tint: .orange,
                    compact: isCompactDevice
                    
                )
                {
                    showCalorieSetupSheet = true
                }
                
                // open workout (no goal)
                ActionButton(
                    label: "Open",
                    icon: "play.circle.fill",
                    tint: .green,
                    compact: isCompactDevice
                )
                {
                    manager.path.append(NavState.swimSetup)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
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
    }
    
    // check if any goals are active
    private var hasActiveGoals: Bool {
        return manager.goalDistance > 0 || manager.goalTime > 0 || manager.goalCalories > 0
    }
}

#Preview {
    GoalSwimSetupView()
        .environmentObject(WatchManager())
} 
