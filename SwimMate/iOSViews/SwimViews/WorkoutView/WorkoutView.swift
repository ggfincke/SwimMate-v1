// SwimMate/iOSViews/SwimViews/WorkoutView/WorkoutView.swift

import SwiftUI
import Charts

struct WorkoutView: View
{
    @EnvironmentObject var manager: Manager
    let swim: Swim
    
    @State private var selectedTab = 0
    
    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 20)
            {
                // Header Card - matches home screen style
                WorkoutHeaderCard(swim: swim)
                
                // Key Metrics Grid - matches home screen style
                KeyMetricsGrid(swim: swim)
                
                // Charts Section with TabView
                if !swim.laps.isEmpty
                {
                    ChartsSection(swim: swim, selectedTab: $selectedTab)
                }
                
                // Lap Details - Clean list format
                LapDetailsSection(swim: swim)
            }
            .padding()
        }
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.black)
    }
}

#Preview
{
    let sampleLaps = [
        Lap(duration: 45.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(duration: 42.1, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(duration: 44.7, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(duration: 43.8, metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(duration: 46.3, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 30.5])
    ]

    let sampleSwim = Swim(
        id: UUID(),
        date: Date(),
        duration: 1920,
        totalDistance: 1425,
        totalEnergyBurned: 289,
        poolLength: 25.0,
        laps: sampleLaps
    )

    return NavigationView
    {
        WorkoutView(swim: sampleSwim)
            .environmentObject(Manager())
    }
    .preferredColorScheme(.dark)
}
