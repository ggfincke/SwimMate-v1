// NavigationButtonsSection.swift

import SwiftUI

struct NavigationButtonsSection: View {
    @EnvironmentObject var manager: WatchManager
    @Binding var activeButton: String?
    @Binding var showSettings: Bool
    @Binding var showHealthKitAlert: Bool
    
    var body: some View {
        VStack(spacing: 14)
        {
            quickStartButton
            setGoalButton
            importSetButton
            settingsButton
        }
        .padding(.horizontal, 12)
    }
    
    // MARK: - Navigation Buttons
    
    private var quickStartButton: some View {
        MainButton(
            label: "Quick Start",
            icon: "bolt.fill",
            tint: manager.canStartWorkout ? .green : .gray,
            buttonId: "quick",
            isEnabled: manager.canStartWorkout,
            activeButton: $activeButton
        )
        {
            if manager.canStartWorkout
            {
                withAnimation
                {
                    activeButton = "quick"
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                {
                    manager.path.append(NavState.workoutSetup)
                    activeButton = nil
                }
            }
            else
            {
                showHealthKitAlert = true
            }
        }
    }
    
    private var setGoalButton: some View {
        MainButton(
            label: "Set Goal",
            icon: "target",
            tint: manager.canStartWorkout ? .blue : .gray,
            buttonId: "goal",
            isEnabled: manager.canStartWorkout,
            activeButton: $activeButton
        )
        {
            if manager.canStartWorkout
            {
                withAnimation
                {
                    activeButton = "goal"
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                {
                    manager.path.append(NavState.goalWorkoutSetup)
                    activeButton = nil
                }
            }
            else
            {
                showHealthKitAlert = true
            }
        }
    }
    
    private var importSetButton: some View {
        MainButton(
            label: "Import Set",
            icon: "square.and.arrow.down.fill",
            tint: .orange,
            buttonId: "import",
            isEnabled: true,
            activeButton: $activeButton
        )
        {
            withAnimation
            {
                activeButton = "import"
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                manager.path.append(NavState.importSetView)
                activeButton = nil
            }
        }
    }
    
    private var settingsButton: some View {
        MainButton(
            label: "Settings",
            icon: "gear",
            tint: .gray,
            buttonId: "settings",
            isEnabled: true,
            activeButton: $activeButton
        )
        {
            withAnimation
            {
                activeButton = "settings"
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                showSettings = true
                activeButton = nil
            }
        }
    }
}

#Preview {
    NavigationButtonsSection(
        activeButton: .constant(nil),
        showSettings: .constant(false),
        showHealthKitAlert: .constant(false)
    )
    .environmentObject(WatchManager())
} 