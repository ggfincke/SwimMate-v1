// SwimMate/iOSViews/SwimViews/SetView/SetDetailView/SetDetailView.swift

import SwiftUI

struct SetDetailView: View
{
    let swimSet: SwimSet
    @EnvironmentObject var watchConnector: WatchConnector
    @EnvironmentObject var manager: Manager

    private var difficultyColor: Color
    {
        switch swimSet.difficulty
        {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }

    var body: some View
    {
        ZStack
        {
            // Background gradient
            LinearGradient(
                colors: [difficultyColor.opacity(0.15), difficultyColor.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView
            {
                LazyVStack(spacing: 20)
                {
                    // Hero Section
                    HeroSection(swimSet: swimSet)

                    // Stats Cards
                    StatsSection(swimSet: swimSet)

                    // Description Section
                    if let description = swimSet.description, !description.isEmpty
                    {
                        DescriptionSection(description: description)
                    }

                    // Components Section
                    ComponentsSection(components: swimSet.components)

                    Spacer(minLength: 120)
                }
                .padding(.horizontal)
            }

            // Floating Send Button
            SendToWatchSection(swimSet: swimSet)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview
{
    let sampleSet = SwimSet(
        title: "Sample",
        components: [
            SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30, descend 1-5, 6-10"),
            SetComponent(type: .kick, distance: 500, strokeStyle: .kickboard, instructions: "10x50 kick on 1:00"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down easy"),
        ],
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "A challenging set designed to improve endurance and pace."
    )
    
    SetDetailView(swimSet: sampleSet)
        .environmentObject(Manager())
        .environmentObject(WatchConnector())
}