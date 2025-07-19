// GoalProgressBar.swift

import SwiftUI

struct GoalProgressBar: View

{

    let progress: Double
    let total: Double
    let color: Color
    let isCompact: Bool

    private var progressPercentage: Double
    {
        guard total > 0 else
        {
            return 0 }
            return min(progress / total, 1.0)
        }

        private var progressBarWidth: CGFloat
        {
            isCompact ? 110 : 160 }
            private var progressBarHeight: CGFloat
            {
                isCompact ? 8 : 12 }
                private var cornerRadius: CGFloat
                {
                    isCompact ? 4 : 6 }

                    var body: some View
                    {
                        ZStack(alignment: .leading)
                        {
                            // background bar
                            Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: progressBarHeight)
                            .cornerRadius(cornerRadius)

                            // progress bar
                            Rectangle()
                            .fill(color)
                            .frame(width: max(0, progressPercentage * progressBarWidth), height: progressBarHeight)
                            .cornerRadius(cornerRadius)
                            .animation(.easeInOut(duration: 0.3), value: progressPercentage)
                        }
                        .frame(width: progressBarWidth, height: progressBarHeight)
                    }
                }

                #Preview("50% Progress")
                {
                    GoalProgressBar(
                    progress: 500,
                    total: 1000,
                    color: .blue,
                    isCompact: false
                    )
                }

                #Preview("90% Progress Compact")
                {
                    GoalProgressBar(
                    progress: 900,
                    total: 1000,
                    color: .orange,
                    isCompact: true
                    )
                }

                #Preview("Exceeded Goal")
                {
                    GoalProgressBar(
                    progress: 1200,
                    total: 1000,
                    color: .purple,
                    isCompact: false
                    )
                }