// SwimMate/iOSViews/SwimViews/WorkoutView/Sections/ChartsSection.swift

import Charts
import SwiftUI

// MARK: - Charts Section with TabView

struct ChartsSection: View
{
    let swim: Swim
    @Binding var selectedTab: Int

    var body: some View
    {
        VStack(alignment: .leading, spacing: 12)
        {
            HStack
            {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                    .font(.headline)

                Text("Performance Analytics")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            VStack(spacing: 0)
            {
                // Chart picker
                Picker("Chart Type", selection: $selectedTab)
                {
                    Text("Lap Times").tag(0)
                    Text("SWOLF").tag(1)
                    Text("Strokes").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 16)

                // Chart content
                Group
                {
                    switch selectedTab
                    {
                    case 0:
                        LapTimesChart(swim: swim)
                    case 1:
                        SwolfChart(swim: swim)
                    case 2:
                        StrokeDistributionChart(swim: swim)
                    default:
                        LapTimesChart(swim: swim)
                    }
                }
                .frame(height: 200)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview
{
    let baseDate = Date()
    let sampleLaps = [
        Lap(startDate: baseDate, endDate: baseDate.addingTimeInterval(45.2), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(startDate: baseDate.addingTimeInterval(60), endDate: baseDate.addingTimeInterval(102.1), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(startDate: baseDate.addingTimeInterval(120), endDate: baseDate.addingTimeInterval(164.7), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(startDate: baseDate.addingTimeInterval(180), endDate: baseDate.addingTimeInterval(223.8), metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(startDate: baseDate.addingTimeInterval(300), endDate: baseDate.addingTimeInterval(346.3), metadata: ["HKSwimmingStrokeStyle": 4, "HKSWOLFScore": 30.5]),
        Lap(startDate: baseDate.addingTimeInterval(360), endDate: baseDate.addingTimeInterval(401.9), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 27.3]),
        Lap(startDate: baseDate.addingTimeInterval(480), endDate: baseDate.addingTimeInterval(528.1), metadata: ["HKSwimmingStrokeStyle": 5, "HKSWOLFScore": 32.8]),
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

    return VStack
    {
        ChartsSection(swim: sampleSwim, selectedTab: .constant(0))
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
