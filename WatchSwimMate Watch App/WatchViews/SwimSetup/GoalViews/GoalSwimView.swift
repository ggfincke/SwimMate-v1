// GoalSwimView.swift

import SwiftUI

struct GoalSwimView: View {
    @Environment(WatchManager.self) private var manager
    @State private var showDistanceSetupSheet = false
    @State private var showTimeSetupSheet = false
    @State private var showCalorieSetupSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: manager.isCompactDevice ? 8 : 10) {
                Text("Set Your Goal")
                    .font(.system(size: manager.isCompactDevice ? 16 : 18, weight: .semibold))
                
                // Current goals display
                CurrentGoalsDisplaySection()
                
                // Goal setup buttons
                GoalSetupButtonsSection(
                    showDistanceSetupSheet: $showDistanceSetupSheet,
                    showTimeSetupSheet: $showTimeSetupSheet,
                    showCalorieSetupSheet: $showCalorieSetupSheet
                )
                
                // Action buttons
                ActionButtonsSection()
            }
            .padding(.horizontal, manager.isCompactDevice ? 12 : 16)
            .padding(.bottom, manager.isCompactDevice ? 12 : 16)
            .navigationTitle("Goal Setup")
            // sheets for goal setup (distance, time, calories)
            .sheet(isPresented: $showDistanceSetupSheet) 
            {
                DistanceSetupView()
            }
            .sheet(isPresented: $showTimeSetupSheet) 
            {
                TimeSetupView()
            }
            .sheet(isPresented: $showCalorieSetupSheet) 
            {
                CalorieSetupView()
            }
        }
    }
}

#Preview 
{
    GoalSwimView()
        .environment(WatchManager())
} 
