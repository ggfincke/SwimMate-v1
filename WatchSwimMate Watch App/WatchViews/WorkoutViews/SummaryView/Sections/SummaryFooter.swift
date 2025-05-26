// SummaryFooter.swift

import SwiftUI

// Footer of summary view
struct SummaryFooter: View
{
    @Environment(\.dismiss) private var dismiss
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
                manager.resetWorkout()
                dismiss()
            }
            
            // secondary info
            Text("Workout saved to Health app")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}
