// SwimControlsView.swift

import SwiftUI
import WatchKit

struct SwimControlsView: View
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
                
                // end swim
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
            "End Swim?",
            isPresented: $showEndConfirmation,
            titleVisibility: .visible
        )
        {
            Button("End Swim", role: .destructive)
            {
                endSwim()
            }
            Button("Cancel", role: .cancel) { }
        }
        message:
        {
            Text("This will save your swim and return to the main screen.")
        }
    }
    
    // MARK: - Actions
    private func endSwim()
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
    SwimControlsView()
        .environmentObject(WatchManager())
}
