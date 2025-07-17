// SwimMate/Model/Sets/SwimSetExamples.swift

import Foundation

/// Example swim sets demonstrating the component-based architecture
struct SwimSetExamples 
{
    // MARK: - Beginner Sets
    static let beginnerFreestyle = SwimSet(
        title: "Beginner Freestyle",
        components: [
            SetComponent(
                type: .warmup,
                distance: 200,
                strokeStyle: .freestyle,
                instructions: "Easy pace, focus on breathing",
                restPeriod: 30
            ),
            SetComponent(
                type: .drill,
                distance: 100,
                strokeStyle: .freestyle,
                instructions: "Catch-up drill",
                restPeriod: 20
            ),
            SetComponent(
                type: .swim,
                distance: 400,
                strokeStyle: .freestyle,
                instructions: "Steady pace",
                restPeriod: 60
            ),
            SetComponent(
                type: .cooldown,
                distance: 100,
                strokeStyle: .freestyle,
                instructions: "Easy recovery"
            )
        ],
        difficulty: .beginner,
        estimatedDuration: 25 * 60, // 25 minutes
        description: "Basic freestyle set focusing on technique and endurance"
    )
    
    // MARK: - Intermediate Sets
    static let intermediateIM = SwimSet(
        title: "IM Pyramid",
        components: [
            SetComponent(
                type: .warmup,
                distance: 300,
                strokeStyle: .freestyle,
                restPeriod: 30
            ),
            SetComponent(
                type: .swim,
                distance: 100,
                strokeStyle: .butterfly,
                instructions: "Build to fast",
                restPeriod: 60
            ),
            SetComponent(
                type: .swim,
                distance: 200,
                strokeStyle: .backstroke,
                instructions: "Steady pace",
                restPeriod: 60
            ),
            SetComponent(
                type: .swim,
                distance: 300,
                strokeStyle: .breaststroke,
                instructions: "Focus on technique",
                restPeriod: 90
            ),
            SetComponent(
                type: .swim,
                distance: 200,
                strokeStyle: .freestyle,
                instructions: "Fast pace",
                restPeriod: 60
            ),
            SetComponent(
                type: .swim,
                distance: 100,
                strokeStyle: .mixed,
                instructions: "Choice stroke",
                restPeriod: 30
            ),
            SetComponent(
                type: .cooldown,
                distance: 200,
                strokeStyle: .freestyle
            )
        ],
        difficulty: .intermediate,
        estimatedDuration: 40 * 60, // 40 minutes
        description: "Individual Medley pyramid set"
    )
    
    // MARK: - Advanced Sets
    static let advancedSprint = SwimSet(
        title: "Sprint Training",
        components: [
            SetComponent(
                type: .warmup,
                distance: 400,
                strokeStyle: .freestyle,
                restPeriod: 30
            ),
            SetComponent(
                type: .drill,
                distance: 200,
                strokeStyle: .freestyle,
                instructions: "Sprint technique drills",
                restPeriod: 30
            ),
            SetComponent(
                type: .kick,
                distance: 200,
                strokeStyle: .freestyle,
                instructions: "Fast kick with board",
                restPeriod: 45
            ),
            SetComponent(
                type: .swim,
                distance: 50,
                strokeStyle: .freestyle,
                instructions: "All-out sprint",
                restPeriod: 120
            ),
            SetComponent(
                type: .swim,
                distance: 50,
                strokeStyle: .freestyle,
                instructions: "All-out sprint",
                restPeriod: 120
            ),
            SetComponent(
                type: .swim,
                distance: 50,
                strokeStyle: .freestyle,
                instructions: "All-out sprint",
                restPeriod: 120
            ),
            SetComponent(
                type: .swim,
                distance: 50,
                strokeStyle: .freestyle,
                instructions: "All-out sprint",
                restPeriod: 120
            ),
            SetComponent(
                type: .cooldown,
                distance: 300,
                strokeStyle: .freestyle
            )
        ],
        difficulty: .advanced,
        estimatedDuration: 35 * 60, // 35 minutes
        description: "High-intensity sprint training set"
    )
    
    // MARK: - All Examples
    static let allExamples: [SwimSet] = [
        beginnerFreestyle,
        intermediateIM,
        advancedSprint
    ]
} 