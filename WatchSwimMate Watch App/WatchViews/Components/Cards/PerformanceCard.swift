// PerformanceCard.swift

import SwiftUI

struct PerformanceCard: View

{

    @Environment(WatchManager.self) private var manager
    let title: String
    let value: String
    let subtitle: String
    let trend: Trend
    let color: Color

    enum Trend
    {
        case up, down, stable

        var icon: String
        {
            switch self
            {
                case .up: return "arrow.up.circle.fill"
                case .down: return "arrow.down.circle.fill"
                case .stable: return "minus.circle.fill"
            }
        }

        var color: Color
        {
            switch self
            {
                case .up: return .green
                case .down: return .red
                case .stable: return .gray
            }
        }
    }

    var body: some View
    {
        VStack(spacing: 6)
        {
            // header w/ trend
            HStack
            {
                Text(title)
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)

                Spacer()

                Image(systemName: trend.icon)
                .font(.system(size: 8))
                .foregroundColor(trend.color)
            }

            // value & subtitle
            HStack(alignment: .lastTextBaseline, spacing: 2)
            {
                Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .monospacedDigit()

                Text(subtitle)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
        RoundedRectangle(cornerRadius: 10)
        .fill(Color.black.opacity(0.15))
        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
    }
}


// MARK: - Performance Metrics Section

struct PerformanceMetricsSection: View

{

    @Environment(WatchManager.self) private var manager

    var body: some View
    {
        VStack(spacing: 8)
        {
            // section header
            HStack
            {
                Text("PERFORMANCE")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
                .tracking(0.5)

                Spacer()

                // workout intensity indicator
                IntensityIndicator(heartRate: manager.heartRate)
            }

            // performance stats
            HStack(spacing: 8)
            {
                PerformanceCard(
                title: "Avg HR",
                value: "\(Int(manager.averageHeartRate))",
                subtitle: "bpm",
                trend: getHeartRateTrend(),
                color: .red
                )

                PerformanceCard(
                title: "Stroke Rate",
                value: estimatedStrokeRate,
                subtitle: "spm",
                trend: .stable,
                color: .cyan
                )
            }
        }
    }

    private func getHeartRateTrend() -> PerformanceCard.Trend
    {
        if manager.heartRate > manager.averageHeartRate * 1.05
        {
            return .up
        }
        else if manager.heartRate < manager.averageHeartRate * 0.95
        {
            return .down
        }
        else
        {
            return .stable
        }
    }

    // TODO: implement (currently a placeholder)
    private var estimatedStrokeRate: String
    {
        let baseRate = 30 + Int.random(in: -5...5)
        return "\(baseRate)"
    }
}

