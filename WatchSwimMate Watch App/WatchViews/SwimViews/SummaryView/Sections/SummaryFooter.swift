// SummaryFooter.swift

import SwiftUI

// footer of summary view
struct SummaryFooter: View
{
    @EnvironmentObject var manager: WatchManager
    
    var body: some View
    {
        VStack(spacing: 12)
        {
            // using ActionButton component
            ActionButton(
                label: "Done",
                icon: "checkmark.circle.fill",
                tint: .green
            )
            {
                WKInterfaceDevice.current().play(.click)
                
                // reset workout data & dismiss summary
                manager.resetWorkout()
                manager.showingSummaryView = false
            }
            
            // secondary info
            Text("Workout saved to Health app")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}
