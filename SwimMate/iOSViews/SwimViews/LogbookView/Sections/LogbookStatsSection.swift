// SwimMate/iOSViews/SwimViews/LogbookView/Sections/LogbookStatsSection.swift

import SwiftUI

struct LogbookStatsSection: View {
    @EnvironmentObject var manager: Manager
    let filteredWorkouts: [Swim]
    
    var body: some View {
        HStack(spacing: 12) {
            LogbookStatCard(
                title: "Total Distance",
                value: formatTotalDistance(),
                icon: "ruler",
                color: .blue
            )
            
            LogbookStatCard(
                title: "Total Time",
                value: formatTotalTime(),
                icon: "clock",
                color: .green
            )
            
            LogbookStatCard(
                title: "Avg. Distance",
                value: formatAverageDistance(),
                icon: "chart.bar",
                color: .orange
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    
    // MARK: - Stat Calculations
    private func formatTotalDistance() -> String {
        let total = filteredWorkouts.compactMap { $0.totalDistance }.reduce(0, +)
        return String(format: "%.0f %@", total, manager.preferredUnit.rawValue)
    }
    
    private func formatTotalTime() -> String {
        let totalMinutes = filteredWorkouts.reduce(0) { $0 + Int($1.duration / 60) }
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formatAverageDistance() -> String {
        guard !filteredWorkouts.isEmpty else { return "0 \(manager.preferredUnit.rawValue)" }
        
        let total = filteredWorkouts.compactMap { $0.totalDistance }.reduce(0, +)
        let average = total / Double(filteredWorkouts.count)
        return String(format: "%.0f %@", average, manager.preferredUnit.rawValue)
    }
}