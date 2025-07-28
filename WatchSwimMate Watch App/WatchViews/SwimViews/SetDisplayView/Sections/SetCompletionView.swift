// SetCompletionView.swift

import SwiftUI

// Completion View (Auto-Dismiss)
struct SetCompletionView: View
{
    let onComplete: () -> Void

    var body: some View
    {
        VStack(spacing: 16)
        {
            // completion icon
            ZStack
            {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.green.opacity(0.3), .blue.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
            }

            // completion message
            VStack(spacing: 6)
            {
                Text("Set Complete!")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("Great job! Returning to workout...")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear
        {
            WKInterfaceDevice.current().play(.success)
            onComplete()
        }
    }
}
