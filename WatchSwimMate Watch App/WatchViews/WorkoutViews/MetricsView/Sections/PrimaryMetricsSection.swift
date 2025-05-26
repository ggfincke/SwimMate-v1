// PrimaryMetricsSection.swift

import SwiftUI

// primary metrics
struct PrimaryMetricsSection: View
{
    @EnvironmentObject var manager: WatchManager
    let showSubseconds: Bool
    
    var body: some View
    {
        VStack()
        {
            // current time
            ElapsedTimeView(
                elapsedTime: manager.workoutBuilder?.elapsedTime ?? 0,
                showSubseconds: showSubseconds
            )
            .font(.system(size: 40, weight: .bold, design: .rounded))
            .foregroundStyle(.yellow)
            .monospacedDigit()
            
            // total distance
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text("\(Int(manager.distance.rounded()))")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                    .monospacedDigit()
                
                Text(manager.poolUnit == "meters" ? "m" : "yd")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.blue.opacity(0.8))
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
    }
}
