// WorkoutControlsView.swift

import SwiftUI
import WatchKit

// controls for workout
struct WorkoutControlsView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var showSummary = false
    @State private var showEndConfirmation = false
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            // 2x2 main grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16)
            {
                
                // pause/resume & end
                MainControlButton(
                    icon: manager.running ? "pause.fill" : "play.fill",
                    label: manager.running ? "Pause" : "Resume",
                    color: .yellow
                )
                {
                    withHapticFeedback
                    {
                        manager.togglePause()
                    }
                }
                
                MainControlButton(
                    icon: "stop.fill",
                    label: "End",
                    color: .red
                )
                {
                    withHapticFeedback
                    {
                        showEndConfirmation = true
                    }
                }
                
                // water Lock & Lap
                MainControlButton(
                    icon: "drop.fill",
                    label: "Lock",
                    color: .blue
                )
                {
                    withHapticFeedback
                    {
                        WKInterfaceDevice.current().enableWaterLock()
                    }
                }
                
                MainControlButton(
                    icon: "flag.fill",
                    label: "Lap",
                    color: .green
                )
                {
                    withHapticFeedback
                    {
                        // TODO: Implement lap marking
                        manager.laps += 1
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .confirmationDialog(
            "End Workout?",
            isPresented: $showEndConfirmation,
            titleVisibility: .visible
        )
        {
            Button("End Workout", role: .destructive)
            {
                endWorkout()
            }
            Button("Cancel", role: .cancel) { }
        }
        message:
        {
            Text("This will save your workout and return to the main screen.")
        }
        .sheet(isPresented: $showSummary)
        {
            SwimmingSummaryView()
                .environmentObject(manager)
        }
    }
    
    // MARK: - Actions
    private func endWorkout()
    {
        withHapticFeedback(.success)
        {
            manager.resetNav()
            manager.endWorkout()
            showSummary = true
        }
    }
    
    private func withHapticFeedback<T>(_ type: WKHapticType = .click, action: () -> T) -> T
    {
        WKInterfaceDevice.current().play(type)
        return action()
    }
}


// Preview
#Preview
{
    WorkoutControlsView()
        .environmentObject(WatchManager())
}
