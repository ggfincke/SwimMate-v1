//
//  ChartsSection.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI
import Charts

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
