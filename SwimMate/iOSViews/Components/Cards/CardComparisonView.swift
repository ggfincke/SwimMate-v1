// SwimMate/iOSViews/Components/Cards/CardComparisonView.swift

import SwiftUI

/// View for comparing different card layouts side by side
struct CardComparisonView: View
{
    @EnvironmentObject var manager: Manager
    @State private var selectedCardType: CardType = .compact
    
    enum CardType: String, CaseIterable
    {
        case original = "Original"
        case compact = "Compact"
        case horizontal = "Horizontal"
    }
    
    var body: some View
    {
        NavigationView 
        {
            VStack(spacing: 20) 
            {
                // Card Type Picker
                Picker("Card Type", selection: $selectedCardType) 
                {
                    ForEach(CardType.allCases, id: \.self) 
                    { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Display Area
                ScrollView 
                {
                    cardContent
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Card Comparison")
        }
    }
    
    @ViewBuilder
    private var cardContent: some View
    {
        let sampleSets = createSampleSets()
        
        switch selectedCardType 
        {
        case .original:
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) 
            {
                ForEach(sampleSets.prefix(4), id: \.id) 
                { set in
                    RecommendedSetCard(
                        swimSet: set,
                        isFavorite: false,
                        toggleFavorite: {}
                    )
                }
            }
            
        case .compact:
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) 
            {
                ForEach(sampleSets.prefix(4), id: \.id) 
                { set in
                    CompactSetCard(
                        swimSet: set,
                        isFavorite: false,
                        toggleFavorite: {}
                    )
                }
            }
            
        case .horizontal:
            LazyVStack(spacing: 16) 
            {
                ForEach(sampleSets.prefix(4), id: \.id) 
                { set in
                    HorizontalSetCard(
                        swimSet: set,
                        isFavorite: false,
                        toggleFavorite: {}
                    )
                }
            }
        }
    }
    
    private func createSampleSets() -> [SwimSet]
    {
        [
            SwimSet(
                title: "Sprint Interval Training",
                components: [
                    SetComponent(type: .warmup, distance: 200, strokeStyle: .freestyle),
                    SetComponent(type: .swim, distance: 400, strokeStyle: .freestyle),
                    SetComponent(type: .cooldown, distance: 100, strokeStyle: .freestyle)
                ],
                difficulty: .intermediate,
                description: "High-intensity sprint intervals to build speed and power"
            ),
            SwimSet(
                title: "Endurance Challenge for Distance Swimming",
                components: [
                    SetComponent(type: .warmup, distance: 300, strokeStyle: .freestyle),
                    SetComponent(type: .swim, distance: 800, strokeStyle: .freestyle),
                    SetComponent(type: .swim, distance: 400, strokeStyle: .backstroke),
                    SetComponent(type: .cooldown, distance: 200, strokeStyle: .freestyle)
                ],
                difficulty: .advanced,
                description: "Long distance set designed to build aerobic capacity and endurance for competitive swimmers"
            ),
            SwimSet(
                title: "Beginner Technique",
                components: [
                    SetComponent(type: .warmup, distance: 100, strokeStyle: .freestyle),
                    SetComponent(type: .drill, distance: 200, strokeStyle: .freestyle),
                    SetComponent(type: .swim, distance: 200, strokeStyle: .freestyle)
                ],
                difficulty: .beginner,
                description: "Focus on proper technique and form development"
            ),
            SwimSet(
                title: "Mixed Stroke Workout",
                components: [
                    SetComponent(type: .warmup, distance: 200, strokeStyle: .freestyle),
                    SetComponent(type: .swim, distance: 100, strokeStyle: .butterfly),
                    SetComponent(type: .swim, distance: 100, strokeStyle: .backstroke),
                    SetComponent(type: .swim, distance: 100, strokeStyle: .breaststroke),
                    SetComponent(type: .swim, distance: 100, strokeStyle: .freestyle)
                ],
                difficulty: .intermediate,
                description: "Practice all four competitive strokes"
            )
        ]
    }
}

#Preview 
{
    CardComparisonView()
        .environmentObject(Manager())
}