// SwimMate/ViewModel/Manager+Convenience.swift

import Foundation

// MARK: - Convenience Methods for Common Filter Operations
extension Manager
{
    
    // MARK: - Quick Filter Presets
    func applyBeginnerPreset()
    {
        activeFilters = SetFilters(
            stroke: nil,
            difficulty: .beginner,
            unit: preferredUnit,
            componentTypes: [.warmup, .cooldown],
            distanceRange: .short,
            durationRange: .quick,
            searchText: "",
            showFavorites: false,
            hasWarmup: true,
            hasCooldown: true
        )
    }
    
    func applySprintPreset()
    {
        activeFilters = SetFilters(
            stroke: nil,
            difficulty: .advanced,
            unit: preferredUnit,
            componentTypes: [.swim],
            distanceRange: .short,
            durationRange: .quick,
            searchText: "",
            showFavorites: false,
            hasWarmup: nil,
            hasCooldown: nil
        )
    }
    
    func applyEndurancePreset()
    {
        activeFilters = SetFilters(
            stroke: nil,
            difficulty: .intermediate,
            unit: preferredUnit,
            componentTypes: [],
            distanceRange: .long,
            durationRange: .long,
            searchText: "",
            showFavorites: false,
            hasWarmup: true,
            hasCooldown: true
        )
    }
    
    func applyTechniquePreset()
    {
        activeFilters = SetFilters(
            stroke: nil,
            difficulty: .intermediate,
            unit: preferredUnit,
            componentTypes: [.drill, .swim],
            distanceRange: .medium,
            durationRange: .moderate,
            searchText: "",
            showFavorites: false,
            hasWarmup: true,
            hasCooldown: true
        )
    }
    
    // MARK: - User-Specific Recommendations
    func getPersonalizedSets() -> [SwimSet]
    {
        // Get user's swimming history to determine level
        let userLevel = determineUserLevel()
        let preferredDistance = determinePreferredDistance()
        
        return getSmartRecommendations(for: userLevel, preferredDistance: preferredDistance)
    }
    
    private func determineUserLevel() -> SwimSet.Difficulty
    {
        // Analyze user's past swims to determine their level
        let totalSwims = swims.count
        let averageDistance = swims.isEmpty ? 0 : swims.reduce(into: 0.0) { $0 += $1.totalDistance ?? 0 } / Double(swims.count)
        
        if totalSwims < 5 || averageDistance < 1000
        {
            return .beginner
        }
        else if totalSwims < 20 || averageDistance < 2000
        {
            return .intermediate
        }
        else
        {
            return .advanced
        }
    }
    
    private func determinePreferredDistance() -> DistanceRange
    {
        let averageDistance = swims.isEmpty ? 0 : swims.reduce(into: 0.0) { $0 += $1.totalDistance ?? 0 } / Double(swims.count)
        
        if averageDistance < 1000
        {
            return .short
        }
        else if averageDistance < 2000
        {
            return .medium
        }
        else if averageDistance < 3000
        {
            return .long
        }
        else
        {
            return .ultraLong
        }
    }
    
    // MARK: - Set Analytics
    func getSetAnalytics() -> SetAnalytics
    {
        let allSets = sampleSets
        let filteredSets = self.filteredSets
        
        return SetAnalytics(
            totalSets: allSets.count,
            filteredSets: filteredSets.count,
            averageDistance: filteredSets.isEmpty ? 0 : filteredSets.reduce(0) { $0 + $1.totalDistance } / filteredSets.count,
            averageDuration: filteredSets.compactMap { $0.estimatedDuration }.reduce(0, +) / Double(filteredSets.count),
            difficultyBreakdown: getDifficultyBreakdown(filteredSets),
            strokeBreakdown: getStrokeBreakdown(filteredSets),
            componentBreakdown: getComponentBreakdown(filteredSets)
        )
    }
    
    private func getDifficultyBreakdown(_ sets: [SwimSet]) -> [SwimSet.Difficulty: Int]
    {
        var breakdown: [SwimSet.Difficulty: Int] = [:]
        for set in sets
        {
            breakdown[set.difficulty, default: 0] += 1
        }
        return breakdown
    }
    
    private func getStrokeBreakdown(_ sets: [SwimSet]) -> [SwimStroke: Int]
    {
        var breakdown: [SwimStroke: Int] = [:]
        for set in sets
        {
            if let stroke = set.primaryStroke
            {
                breakdown[stroke, default: 0] += 1
            }
        }
        return breakdown
    }
    
    private func getComponentBreakdown(_ sets: [SwimSet]) -> [SetComponent.ComponentType: Int]
    {
        var breakdown: [SetComponent.ComponentType: Int] = [:]
        for set in sets
        {
            for component in set.components
            {
                breakdown[component.type, default: 0] += 1
            }
        }
        return breakdown
    }
    
    // MARK: - Batch Operations
    func addToFavorites(_ setIds: [UUID])
    {
        favoriteSetIds.formUnion(setIds)
    }
    
    func removeFromFavorites(_ setIds: [UUID])
    {
        favoriteSetIds.subtract(setIds)
    }
    
    func clearFavorites()
    {
        favoriteSetIds.removeAll()
    }
    
    // MARK: - Filter Validation
    func validateFilters() -> [String]
    {
        var warnings: [String] = []
        
        // Check if filters are too restrictive
        if filteredSets.isEmpty
        {
            warnings.append("No sets match your current filters. Consider broadening your criteria.")
        }
        
        // Check if distance range and duration don't align
        if activeFilters.distanceRange == .ultraLong && activeFilters.durationRange == .quick
        {
            warnings.append("Ultra long distance sets typically can't be completed in under 20 minutes.")
        }
        
        // Check if difficulty and components don't align
        if activeFilters.difficulty == .beginner && activeFilters.componentTypes.contains(.pull)
        {
            warnings.append("Pull sets are typically more suited for intermediate or advanced swimmers.")
        }
        
        return warnings
    }
}

// MARK: - Set Analytics Structure
struct SetAnalytics
{
    let totalSets: Int
    let filteredSets: Int
    let averageDistance: Int
    let averageDuration: TimeInterval
    let difficultyBreakdown: [SwimSet.Difficulty: Int]
    let strokeBreakdown: [SwimStroke: Int]
    let componentBreakdown: [SetComponent.ComponentType: Int]
    
    var filterEfficiency: Double
    {
        return totalSets > 0 ? Double(filteredSets) / Double(totalSets) : 0
    }
}

