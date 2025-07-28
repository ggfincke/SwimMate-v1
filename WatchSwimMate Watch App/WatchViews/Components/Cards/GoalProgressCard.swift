// GoalProgressCard.swift

import SwiftUI

struct GoalProgressCard: View

{
    let type: GoalType
    let progress: Double
    let total: Double
    let unit: String
    let color: Color
    let icon: String
    var isTimeFormat: Bool = false
    let formatTime: (TimeInterval) -> String
    let isCompact: Bool

    private var progressPercentage: Double
    {
        guard total > 0
        else
        {
            return 0
        }
        return min(progress / total, 1.0)
    }

    private var percentageText: String
    {
        return "\(Int(progressPercentage * 100))%"
    }

    // sizing
    private var iconSize: CGFloat
    {
        isCompact ? 12 : 16
    }

    private var iconFrameWidth: CGFloat
    {
        isCompact ? 16 : 22
    }

    private var cardPadding: CGFloat
    {
        isCompact ? 6 : 8
    }

    private var cardVerticalPadding: CGFloat
    {
        isCompact ? 6 : 8
    }

    private var textSize: CGFloat
    {
        isCompact ? 10 : 12
    }

    private var percentageSize: CGFloat
    {
        isCompact ? 10 : 13
    }

    var body: some View
    {
        HStack(spacing: isCompact ? 8 : 10)
        {
            // icon
            Image(systemName: icon)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundColor(color)
                .frame(width: iconFrameWidth)

            // progress content
            VStack(alignment: .leading, spacing: isCompact ? 2 : 4)
            {
                // progress bar
                GoalProgressBar(
                    progress: progress,
                    total: total,
                    color: color,
                    isCompact: isCompact
                )

                // progress text
                HStack
                {
                    Text(formatProgressValue())
                        .font(.system(size: textSize, weight: .medium))
                        .foregroundColor(.secondary)

                    Spacer()

                    Text(percentageText)
                        .font(.system(size: percentageSize, weight: .semibold))
                        .foregroundColor(progressPercentage >= 1.0 ? .green : color)
                }
            }
        }
        .padding(.horizontal, cardPadding)
        .padding(.vertical, cardVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: isCompact ? 8 : 10)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    // MARK: helper methods

    private func formatProgressValue() -> String
    {
        if isTimeFormat
        {
            return "\(formatTime(progress))/\(formatTime(total))"
        }
        else
        {
            let progressInt = Int(progress)
            let totalInt = Int(total)
            if unit.isEmpty
            {
                return "\(progressInt)/\(totalInt)"
            }
            else
            {
                return "\(progressInt)/\(totalInt)\(unit)"
            }
        }
    }
}

// preview
#Preview("Distance Goal - Normal")
{
    GoalProgressCard(
        type: .distance,
        progress: 650,
        total: 1000,
        unit: "m",
        color: .blue,
        icon: "figure.pool.swim",
        isTimeFormat: false,
        formatTime: { _ in "" },
        isCompact: false
    )
}

#Preview("Time Goal - Compact")
{
    GoalProgressCard(
        type: .time,
        progress: 1200,
        total: 1800,
        unit: "",
        color: .purple,
        icon: "clock.fill",
        isTimeFormat: true,
        formatTime: { time in
            let minutes = Int(time) / 60
            return "\(minutes)m"
        },
        isCompact: true
    )
}

#Preview("Calories Goal - Exceeded")
{
    GoalProgressCard(
        type: .calories,
        progress: 450,
        total: 400,
        unit: "kcal",
        color: .orange,
        icon: "flame.fill",
        isTimeFormat: false,
        formatTime: { _ in "" },
        isCompact: false
    )
}
