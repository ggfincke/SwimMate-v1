//
//  SimpleMetricCard.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI

struct SimpleMetricCard: View
{
    let emoji: String
    let value: String
    let label: String
    let subtitle: String
    
    var body: some View
    {
        VStack(spacing: 8)
        {
            Text(emoji)
                .font(.system(size: 28))
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 2)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview
{
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: 12) {
        SimpleMetricCard(
            emoji: "⏱️",
            value: "2:15",
            label: "Average Pace",
            subtitle: "per 100m"
        )
        
        SimpleMetricCard(
            emoji: "📏",
            value: "25 m",
            label: "Pool Length",
            subtitle: "configured"
        )
        
        SimpleMetricCard(
            emoji: "🔄",
            value: "32",
            label: "Total Laps",
            subtitle: "completed"
        )
        
        SimpleMetricCard(
            emoji: "🎯",
            value: "28.5",
            label: "Avg SWOLF",
            subtitle: "efficiency"
        )
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
