// MetricsView.swift

import SwiftUI

// MetricsView
struct MetricsView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var isVisible = false
    
    // spacing based on device size
    private var sectionSpacing: CGFloat
    {
        manager.isCompactDevice ? 4 : 6
    }
    
    private var horizontalPadding: CGFloat
    {
        manager.isCompactDevice ? 2 : 4
    }
    
    private var topPadding: CGFloat
    {
        manager.isCompactDevice ? 6 : 10
    }
    
    private var bottomPadding: CGFloat
    {
        manager.isCompactDevice ? 2 : 4
    }
    
    var body: some View
    {
        VStack(spacing: sectionSpacing)
        {
            PrimaryMetricsSection()
            SecondaryMetricsGrid()
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .onAppear
        {
            withAnimation
            {
                isVisible = true
            }
        }
    }
}

// preview
#Preview("Standard Size")
{
    MetricsView()
        .environmentObject({
            let manager = WatchManager()
            manager.distance = 750
            manager.elapsedTime = 1234.56
            manager.heartRate = 142
            manager.activeEnergy = 285
            manager.laps = 15
            return manager
        }())
}

#Preview("Compact Size")
{
    MetricsView()
        .environmentObject({
            let manager = WatchManager()
            manager.distance = 750
            manager.elapsedTime = 1234.56
            manager.heartRate = 142
            manager.activeEnergy = 285
            manager.laps = 15
            return manager
        }())
}
