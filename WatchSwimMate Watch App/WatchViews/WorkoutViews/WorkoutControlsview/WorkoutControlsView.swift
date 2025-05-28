// WorkoutControlsView.swift - Responsive version

import SwiftUI
import WatchKit

struct WorkoutControlsView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var showEndConfirmation = false
    
    // responsive sizing
    private var buttonSpacing: CGFloat
    {
        manager.isCompactDevice ? 10 : 16
    }
    
    private var horizontalPadding: CGFloat
    {
        manager.isCompactDevice ? 12 : 20
    }
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            // 2x2 responsive grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: buttonSpacing),
                GridItem(.flexible(), spacing: buttonSpacing)
            ], spacing: buttonSpacing)
            {
                // pause/resume
                MainControlButton(
                    icon: manager.running ? "pause.fill" : "play.fill",
                    label: manager.running ? "Pause" : "Resume",
                    color: .yellow,
                    isCompact: manager.isCompactDevice
                )
                {
                    withHapticFeedback
                    {
                        manager.togglePause()
                    }
                }
                
                // end workout
                MainControlButton(
                    icon: "stop.fill",
                    label: "End",
                    color: .red,
                    isCompact: manager.isCompactDevice
                )
                {
                    withHapticFeedback
                    {
                        showEndConfirmation = true
                    }
                }
                
                // water lock
                MainControlButton(
                    icon: "drop.fill",
                    label: "Lock",
                    color: .blue,
                    isCompact: manager.isCompactDevice
                )
                {
                    withHapticFeedback
                    {
                        WKInterfaceDevice.current().enableWaterLock()
                    }
                }
                
                // lap marker
                MainControlButton(
                    icon: "flag.fill",
                    label: "Lap",
                    color: .green,
                    isCompact: manager.isCompactDevice
                )
                {
                    withHapticFeedback
                    {
                        manager.laps += 1
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
            
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
    }
    
    // MARK: - Actions
    private func endWorkout()
    {
        withHapticFeedback(.success)
        {
            manager.resetNav()
            manager.endWorkout()
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
