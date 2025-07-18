// SwimMate/iOSViews/SwimViews/LogbookView/Sections/LogbookStatsSection.swift

import SwiftUI

struct LogbookStatsSection: View {
    @EnvironmentObject var manager: Manager
    let filteredWorkouts: [Swim]
    
    var body: some View {
        HStack(spacing: 12) {
            LogbookStatCard(
                title: "Total Distance",
                value: manager.formatTotalDistance(from: filteredWorkouts),
                icon: "ruler",
                color: .blue
            )
            
            LogbookStatCard(
                title: "Total Time",
                value: manager.formatTotalTime(from: filteredWorkouts),
                icon: "clock",
                color: .green
            )
            
            LogbookStatCard(
                title: "Avg. Distance",
                value: manager.formatAverageDistance(from: filteredWorkouts),
                icon: "chart.bar",
                color: .orange
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

#Preview {
    LogbookStatsSection(filteredWorkouts: [])
        .environmentObject(Manager())
}