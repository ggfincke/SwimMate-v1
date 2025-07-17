
// SwimMate/Model/Sets/SwimSet.swift

import Foundation

/// Swim set structure for watch consumption - composed of multiple components
struct SwimSet: Identifiable, Hashable, Codable
{
    // MARK: - Properties
    let id: UUID
    let title: String
    let components: [SetComponent]
    let measureUnit: MeasureUnit
    let difficulty: Difficulty
    let estimatedDuration: TimeInterval? // estimated completion time
    let description: String?
    
    // MARK: - Difficulty Levels
    enum Difficulty: String, CaseIterable, Codable
    {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var description: String 
        {
            return rawValue
        }
    }
    
    // MARK: - Initialization
    init(id: UUID = UUID(),
         title: String,
         components: [SetComponent],
         measureUnit: MeasureUnit = .meters,
         difficulty: Difficulty = .intermediate,
         estimatedDuration: TimeInterval? = nil,
         description: String? = nil)
    {
        self.id = id
        self.title = title
        self.components = components
        self.measureUnit = measureUnit
        self.difficulty = difficulty
        self.estimatedDuration = estimatedDuration
        self.description = description
    }
    
    // MARK: - Computed Properties
    /// Total distance across all components
    var totalDistance: Int
    {
        components.reduce(0) { $0 + $1.distance }
    }
    
    /// Primary stroke style (most common across components)
    var primaryStroke: StrokeStyle?
    {
        let strokes = components.compactMap { $0.strokeStyle }
        guard !strokes.isEmpty else { return nil }
        
        // Find most frequent stroke
        let strokeCounts = Dictionary(grouping: strokes, by: { $0 })
            .mapValues { $0.count }
        
        return strokeCounts.max(by: { $0.value < $1.value })?.key
    }
    
    /// Total estimated rest time
    var totalRestTime: TimeInterval
    {
        components.compactMap { $0.restPeriod }.reduce(0, +)
    }
    
    // MARK: - Methods
    /// Calculate total laps needed for this set
    func totalLaps(poolLength: Double) -> Int
    {
        components.reduce(0) 
        { total, component in
            total + component.lapCount(poolLength: poolLength, measureUnit: measureUnit)
        }
    }
    
    /// Get summary for watch display
    func watchSummary(poolLength: Double) -> String
    {
        let distance = "\(totalDistance)\(measureUnit.abbreviation)"
        let laps = totalLaps(poolLength: poolLength)
        
        if let stroke = primaryStroke {
            return "\(distance) • \(laps) laps • \(stroke.description)"
        } else {
            return "\(distance) • \(laps) laps • Mixed"
        }
    }
}

