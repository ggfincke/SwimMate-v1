// SwimMate/iOSViews/SwimViews/WorkoutView/WorkoutView.swift

import Charts
import SwiftUI

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
    let baseDate = Date()
    let sampleLaps = [
        Lap(startDate: baseDate, endDate: baseDate.addingTimeInterval(45.2), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(startDate: baseDate.addingTimeInterval(60), endDate: baseDate.addingTimeInterval(102.1), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(startDate: baseDate.addingTimeInterval(120), endDate: baseDate.addingTimeInterval(164.7), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(startDate: baseDate.addingTimeInterval(180), endDate: baseDate.addingTimeInterval(223.8), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 31.1]),
        Lap(startDate: baseDate.addingTimeInterval(300), endDate: baseDate.addingTimeInterval(346.3), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 30.5]),
    ]

    let sampleSwim = Swim(
        id: UUID(),
        startDate: baseDate,
        endDate: baseDate.addingTimeInterval(1920),
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
