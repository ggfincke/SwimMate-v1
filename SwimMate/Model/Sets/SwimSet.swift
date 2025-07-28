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
    var primaryStroke: SwimStroke?
    {
        let strokes = components.compactMap { $0.strokeStyle }
        guard !strokes.isEmpty else { return nil }

        // Find most frequent stroke
        let strokeCounts = Dictionary(grouping: strokes, by: { $0 })
            .mapValues { $0.count }

        return strokeCounts.max(by: { $0.value < $1.value })?.key
    }
    
    /// Stroke tags for filtering - based on set focus, not individual components
    var strokeTags: Set<SwimStroke>
    {
        // Get strokes from main swim components (ignore warmup/cooldown mixed strokes)
        let mainComponents = components.filter { component in
            component.type == .swim || component.type == .drill || component.type == .kick || component.type == .pull
        }
        
        let mainStrokes = mainComponents.compactMap { $0.strokeStyle }
            .filter { $0 != .mixed && $0 != .kickboard } // Filter out non-specific strokes
        
        guard !mainStrokes.isEmpty else { return [] }
        
        // Calculate stroke distribution by distance
        let strokeDistances = Dictionary(grouping: mainComponents) { $0.strokeStyle }
            .compactMapValues { components in
                components.first?.strokeStyle == .mixed || components.first?.strokeStyle == .kickboard ? nil : 
                components.reduce(0) { $0 + $1.distance }
            }
        
        let totalMainDistance = strokeDistances.values.reduce(0, +)
        guard totalMainDistance > 0 else { return [] }
        
        var tags: Set<SwimStroke> = []
        
        // Add strokes that make up at least 20% of the main work
        for (strokeOpt, distance) in strokeDistances {
            guard let stroke = strokeOpt else { continue }
            let percentage = Double(distance) / Double(totalMainDistance)
            if percentage >= 0.2 // 20% threshold
            {
                tags.insert(stroke)
            }
        }
        
        // Special case: If set has all 4 strokes represented, tag as IM
        let allStrokes: Set<SwimStroke> = [.freestyle, .backstroke, .breaststroke, .butterfly]
        if tags.count >= 3 && allStrokes.isSubset(of: Set(mainStrokes))
        {
            // This is an IM set - clear individual stroke tags
            tags = []
            // We'll handle IM identification separately in filtering
        }
        
        return tags
    }
    
    /// Whether this set is an Individual Medley focused set
    var isIMSet: Bool
    {
        // Check if title contains IM keywords
        let imKeywords = ["im", "individual medley", "medley"]
        let titleLower = title.lowercased()
        
        if imKeywords.contains(where: { titleLower.contains($0) })
        {
            return true
        }
        
        // Check if main components include all 4 strokes
        let mainComponents = components.filter { component in
            component.type == .swim || component.type == .drill
        }
        
        let mainStrokes = Set(mainComponents.compactMap { $0.strokeStyle })
        let allStrokes: Set<SwimStroke> = [.freestyle, .backstroke, .breaststroke, .butterfly]
        
        return allStrokes.isSubset(of: mainStrokes)
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

        if let stroke = primaryStroke
        {
            return "\(distance) • \(laps) laps • \(stroke.description)"
        }
        else
        {
            return "\(distance) • \(laps) laps • Mixed"
        }
    }
}
