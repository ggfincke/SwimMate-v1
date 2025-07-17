//
//  LapDetailsSection.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI

// MARK: - Lap Details Section
struct LapDetailsSection: View
{
    let swim: Swim
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 12)
        {
            HStack
            {
                Image(systemName: "list.bullet")
                    .foregroundColor(.blue)
                    .font(.headline)
                
                Text("Lap Details")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 1)
            {
                // Header
                HStack {
                    Text("Lap")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 40, alignment: .leading)
                    
                    Text("Stroke")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Time")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 70, alignment: .trailing)
                    
                    Text("SWOLF")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                
                // Lap rows - scrollable for large datasets
                ScrollView
                {
                    LazyVStack(spacing: 1)
                    {
                        ForEach(Array(swim.laps.enumerated()), id: \.offset) { index, lap in
                            SimpleLapRow(
                                lapNumber: index + 1,
                                lap: lap
                            )
                        }
                    }
                }
                .frame(maxHeight: 300) // Limit height for better scaling
            }
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
        }
    }
}

#Preview
{
    let sampleLaps = [
        Lap(duration: 45.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(duration: 42.1, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(duration: 44.7, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(duration: 43.8, metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(duration: 46.3, metadata: ["HKSwimmingStrokeStyle": 4, "HKSWOLFScore": 30.5]),
        Lap(duration: 41.9, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 27.3]),
        Lap(duration: 48.1, metadata: ["HKSwimmingStrokeStyle": 5, "HKSWOLFScore": 32.8]),
        Lap(duration: 44.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.9])
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

    return VStack {
        LapDetailsSection(swim: sampleSwim)
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
