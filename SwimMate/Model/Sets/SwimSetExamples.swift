// SwimMate/Model/Sets/SwimSetExamples.swift

import Foundation

/// Example swim sets demonstrating the component-based architecture
enum SwimSetExamples
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
            ),
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
            ),
        ],
        difficulty: .intermediate,
        estimatedDuration: 40 * 60, // 40 minutes
        description: "Individual Medley pyramid set"
    )

    static let beginnerIM = SwimSet(
        title: "Beginner IM Introduction",
        components: [
            SetComponent(
                type: .warmup,
                distance: 200,
                strokeStyle: .freestyle,
                instructions: "Easy warm-up",
                restPeriod: 30
            ),
            SetComponent(
                type: .drill,
                distance: 100,
                strokeStyle: .butterfly,
                instructions: "2x50 butterfly arms only",
                restPeriod: 45
            ),
            SetComponent(
                type: .drill,
                distance: 100,
                strokeStyle: .backstroke,
                instructions: "2x50 backstroke technique",
                restPeriod: 30
            ),
            SetComponent(
                type: .drill,
                distance: 100,
                strokeStyle: .breaststroke,
                instructions: "2x50 breaststroke pulls",
                restPeriod: 45
            ),
            SetComponent(
                type: .swim,
                distance: 100,
                strokeStyle: .mixed,
                instructions: "4x25 IM order (fly, back, breast, free)",
                restPeriod: 60
            ),
            SetComponent(
                type: .cooldown,
                distance: 100,
                strokeStyle: .freestyle,
                instructions: "Easy recovery"
            ),
        ],
        difficulty: .beginner,
        estimatedDuration: 30 * 60,
        description: "Introduction to Individual Medley strokes and order"
    )

    static let intermediateIMDistance = SwimSet(
        title: "IM Distance Builder",
        components: [
            SetComponent(
                type: .warmup,
                distance: 400,
                strokeStyle: .freestyle,
                instructions: "Build every 100m",
                restPeriod: 30
            ),
            SetComponent(
                type: .swim,
                distance: 200,
                strokeStyle: .mixed,
                instructions: "2x100 IM, focus on transitions",
                restPeriod: 90
            ),
            SetComponent(
                type: .swim,
                distance: 300,
                strokeStyle: .mixed,
                instructions: "3x100 IM, steady pace",
                restPeriod: 75
            ),
            SetComponent(
                type: .kick,
                distance: 200,
                strokeStyle: .mixed,
                instructions: "4x50 IM kick order",
                restPeriod: 45
            ),
            SetComponent(
                type: .swim,
                distance: 400,
                strokeStyle: .mixed,
                instructions: "1x400 IM, race pace",
                restPeriod: 120
            ),
            SetComponent(
                type: .cooldown,
                distance: 200,
                strokeStyle: .freestyle
            ),
        ],
        difficulty: .intermediate,
        estimatedDuration: 45 * 60,
        description: "Building endurance for longer IM distances"
    )

    // MARK: - Advanced Sets

    static let advancedIMSet = SwimSet(
        title: "Advanced IM Training",
        components: [
            SetComponent(
                type: .warmup,
                distance: 600,
                strokeStyle: .freestyle,
                instructions: "Build every 200m",
                restPeriod: 30
            ),
            SetComponent(
                type: .drill,
                distance: 200,
                strokeStyle: .mixed,
                instructions: "IM stroke technique - 50 each stroke",
                restPeriod: 30
            ),
            SetComponent(
                type: .swim,
                distance: 400,
                strokeStyle: .mixed,
                instructions: "4x100 IM descend 1-4",
                restPeriod: 90
            ),
            SetComponent(
                type: .swim,
                distance: 200,
                strokeStyle: .mixed,
                instructions: "8x25 IM order fast",
                restPeriod: 30
            ),
            SetComponent(
                type: .swim,
                distance: 400,
                strokeStyle: .mixed,
                instructions: "1x400 IM time trial",
                restPeriod: 180
            ),
            SetComponent(
                type: .swim,
                distance: 200,
                strokeStyle: .mixed,
                instructions: "2x100 IM broken at 50",
                restPeriod: 60
            ),
            SetComponent(
                type: .cooldown,
                distance: 300,
                strokeStyle: .freestyle
            ),
        ],
        difficulty: .advanced,
        estimatedDuration: 50 * 60,
        description: "High-intensity IM training with technique focus"
    )

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
            ),
        ],
        difficulty: .advanced,
        estimatedDuration: 35 * 60, // 35 minutes
        description: "High-intensity sprint training set"
    )

    // MARK: - All Examples

    static let allExamples: [SwimSet] = [
        beginnerFreestyle,
        beginnerIM,
        intermediateIM,
        intermediateIMDistance,
        advancedIMSet,
        advancedSprint,
    ]
}
