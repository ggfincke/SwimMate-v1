// SwimMate/iOSViews/SwimViews/SetView/SetDetailView/Sections/StatsSection.swift

import SwiftUI

struct StatsSection: View
{
    let swimSet: SwimSet

    private var difficultyColor: Color
    {
        switch swimSet.difficulty
        {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }

    private var estimatedDurationText: String
    {
        if let duration = swimSet.estimatedDuration
        {
            let minutes = Int(duration / 60)
            return "\(minutes) min"
        }
        return "~45 min"
    }

    var body: some View
    {
        HStack(spacing: 12)
        {
            DetailStatCard(
                title: "Distance",
                value: "\(swimSet.totalDistance)",
                unit: swimSet.measureUnit.rawValue,
                icon: "ruler",
                color: .blue
            )

            DetailStatCard(
                title: "Duration",
                value: estimatedDurationText,
                unit: "",
                icon: "clock",
                color: .orange
            )

            DetailStatCard(
                title: "Difficulty",
                value: swimSet.difficulty.rawValue,
                unit: "",
                icon: "chart.bar.fill",
                color: difficultyColor
            )
        }
    }
}

#Preview
{
    let sampleSet = SwimSet(
        title: "Endurance Builder",
        components: [
            SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30"),
        ],
        measureUnit: .meters,
        difficulty: .intermediate,
        estimatedDuration: 2700,
        description: "A challenging set designed to improve endurance."
    )

    StatsSection(swimSet: sampleSet)
        .padding()
}
