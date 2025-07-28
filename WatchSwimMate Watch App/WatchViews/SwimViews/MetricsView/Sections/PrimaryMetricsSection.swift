// PrimaryMetricsSection.swift

import SwiftUI

// primary metrics
struct PrimaryMetricsSection: View

{
    @Environment(WatchManager.self) private var manager

    // responsive font sizes
    private var timeFontSize: CGFloat
    {
        manager.isCompactDevice ? 26 : 32
    }

    private var distanceFontSize: CGFloat
    {
        manager.isCompactDevice ? 18 : 24
    }

    private var distanceUnitSize: CGFloat
    {
        manager.isCompactDevice ? 8 : 10
    }

    private var verticalSpacing: CGFloat
    {
        manager.isCompactDevice ? 0 : 2
    }

    var body: some View
    {
        VStack(spacing: verticalSpacing)
        {
            // current time
            ElapsedTimeView(
                elapsedTime: manager.elapsedTime,
                showSubseconds: manager.elapsedTime < 3600
            )
            .font(.system(size: timeFontSize, weight: .bold, design: .rounded))
            .foregroundStyle(.yellow)
            .monospacedDigit()

            // total distance
            HStack(alignment: .lastTextBaseline, spacing: 2)
            {
                Text("\(Int(manager.distance.rounded()))")
                    .font(.system(size: distanceFontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                    .monospacedDigit()

                Text(manager.poolUnit == "meters" ? "m" : "yd")
                    .font(.system(size: distanceUnitSize, weight: .semibold, design: .rounded))
                    .foregroundColor(.blue.opacity(0.8))
            }
        }
        .padding(.vertical, verticalSpacing)
        .padding(.horizontal, verticalSpacing)
    }
}

// preview
#Preview("Standard Size")
{
    PrimaryMetricsSection()
        .environment({
            let manager = WatchManager()
            manager.distance = 750
            manager.elapsedTime = 1234.56
            return manager
        }())
}

#Preview("Compact Size")
{
    PrimaryMetricsSection()
        .environment({
            let manager = WatchManager()
            manager.distance = 750
            manager.elapsedTime = 1234.56
            return manager
        }())
}
