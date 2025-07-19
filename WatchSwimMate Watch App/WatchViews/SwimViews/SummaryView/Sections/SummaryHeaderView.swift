// SummaryHeaderView.swift

import SwiftUI

// summary header
struct SummaryHeaderView: View

{

    @Environment(WatchManager.self) private var manager

    var body: some View
    {
        VStack(spacing: 12)
        {
            // achievement icon
            ZStack
            {
                Circle()
                .fill(
                LinearGradient(
                colors: [.blue.opacity(0.2), .green.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
                )
                )
                .frame(width: 60, height: 60)

                Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.green)
            }

            // congratulations message
            VStack(spacing: 4)
            {
                Text("Workout Complete!")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

                Text(getCompletionMessage())
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            }
        }
    }

    private func getCompletionMessage() -> String
    {
        let distance = manager.workout?.totalDistance?.doubleValue(for: .meter()) ?? manager.distance
        let duration = manager.workout?.duration ?? 2400

        if distance > 2000
        {
            return "Outstanding distance! You're a swimming champion! 🏆"
        }
        else if duration > 3600
        {
            return "Incredible endurance! You pushed through! 💪"
        }
        else if distance > 1000
        {
            return "Great workout! You're making excellent progress! 🌟"
        }
        else
        {
            return "Well done! Every swim counts! 🏊‍♂️"
        }
    }
}
