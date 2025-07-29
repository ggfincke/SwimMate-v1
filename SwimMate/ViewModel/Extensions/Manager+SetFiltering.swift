// SwimMate/ViewModel/Extensions/Manager+SetFiltering.swift

import Foundation

// MARK: - Set Filtering Extension

extension Manager
{
    // MARK: - Filter Options

    struct SetFilters: Equatable
    {
        var strokes: Set<SwimStroke>
        var difficulty: SwimSet.Difficulty?
        var unit: MeasureUnit?
        var componentTypes: Set<SetComponent.ComponentType>
        var distanceRange: DistanceRange
        var durationRange: DurationRange
        var searchText: String
        var showFavorites: Bool
        var hasWarmup: Bool?
        var hasCooldown: Bool?
        var isIMFilter: Bool

        static let defaultFilters = SetFilters(
            strokes: [],
            difficulty: nil,
            unit: nil,
            componentTypes: [],
            distanceRange: .any,
            durationRange: .any,
            searchText: "",
            showFavorites: false,
            hasWarmup: nil,
            hasCooldown: nil,
            isIMFilter: false
        )
    }

    enum DistanceRange: String, CaseIterable
    {
        case any = "Any"
        case short = "Short (< 1000)"
        case medium = "Medium (1000-2000)"
        case long = "Long (2000-3000)"
        case ultraLong = "Ultra Long (> 3000)"

        var range: ClosedRange<Int>?
        {
            switch self
            {
            case .any: return nil
            case .short: return 0 ... 999
            case .medium: return 1000 ... 2000
            case .long: return 2000 ... 3000
            case .ultraLong: return 3001 ... Int.max
            }
        }
    }

    enum DurationRange: String, CaseIterable
    {
        case any = "Any"
        case quick = "Quick (< 20 min)"
        case moderate = "Moderate (20-40 min)"
        case long = "Long (40-60 min)"
        case extended = "Extended (> 60 min)"

        var range: ClosedRange<TimeInterval>?
        {
            switch self
            {
            case .any: return nil
            case .quick: return 0 ... 1200 // 20 minutes
            case .moderate: return 1200 ... 2400 // 20-40 minutes
            case .long: return 2400 ... 3600 // 40-60 minutes
            case .extended: return 3600 ... TimeInterval.greatestFiniteMagnitude
            }
        }
    }

    // MARK: - Published Filter State

    // MARK: - Computed Properties

    var filteredSets: [SwimSet]
    {
        return filterSets(sampleSets, with: activeFilters)
    }
    
    var isSearchActive: Bool
    {
        return !activeFilters.searchText.isEmpty
    }

    var recommendedSets: [SwimSet]
    {
        let baseFilters = SetFilters(
            strokes: preferredStroke.map { [$0] } ?? [],
            difficulty: nil,
            unit: preferredUnit,
            componentTypes: [],
            distanceRange: .any,
            durationRange: .any,
            searchText: "",
            showFavorites: false,
            hasWarmup: nil,
            hasCooldown: nil,
            isIMFilter: false
        )

        let recommended = filterSets(sampleSets, with: baseFilters)

        // Sort by difficulty preference (beginner first for new users)
        return recommended.sorted
        { set1, set2 in
            let difficultyOrder: [SwimSet.Difficulty] = [.beginner, .intermediate, .advanced]
            let index1 = difficultyOrder.firstIndex(of: set1.difficulty) ?? 0
            let index2 = difficultyOrder.firstIndex(of: set2.difficulty) ?? 0
            return index1 < index2
        }.prefix(5).map { $0 }
    }

    var filterSummary: String
    {
        var components: [String] = []

        if !activeFilters.strokes.isEmpty
        {
            let strokes = activeFilters.strokes.map { $0.description }.sorted().joined(separator: " + ")
            components.append(strokes)
        }

        if let difficulty = activeFilters.difficulty
        {
            components.append(difficulty.rawValue)
        }

        if let unit = activeFilters.unit
        {
            components.append(unit.rawValue)
        }

        if activeFilters.distanceRange != .any
        {
            components.append(activeFilters.distanceRange.rawValue)
        }

        if activeFilters.durationRange != .any
        {
            components.append(activeFilters.durationRange.rawValue)
        }

        if !activeFilters.componentTypes.isEmpty
        {
            let types = activeFilters.componentTypes.map { $0.rawValue }.joined(separator: ", ")
            components.append(types)
        }

        if activeFilters.showFavorites
        {
            components.append("Favorites")
        }
        
        if activeFilters.isIMFilter
        {
            components.append("IM")
        }

        if let hasWarmup = activeFilters.hasWarmup
        {
            components.append(hasWarmup ? "Has Warmup" : "No Warmup")
        }

        if let hasCooldown = activeFilters.hasCooldown
        {
            components.append(hasCooldown ? "Has Cooldown" : "No Cooldown")
        }

        return components.isEmpty ? "All Sets" : components.joined(separator: " • ")
    }

    // MARK: - Filtering Logic

    private func filterSets(_ sets: [SwimSet], with filters: SetFilters) -> [SwimSet]
    {
        return sets.filter
        { set in
            // IM filter
            if filters.isIMFilter
            {
                if !set.isIMSet
                {
                    return false
                }
            }
            
            // Stroke filter
            if !filters.strokes.isEmpty
            {
                if filters.strokes.isDisjoint(with: set.strokeTags)
                {
                    return false
                }
            }

            // Difficulty filter
            if let difficulty = filters.difficulty, set.difficulty != difficulty
            {
                return false
            }

            // Unit filter
            if let unit = filters.unit, set.measureUnit != unit
            {
                return false
            }

            // Distance range filter
            if let range = filters.distanceRange.range, !range.contains(set.totalDistance)
            {
                return false
            }

            // Duration range filter
            if let range = filters.durationRange.range,
               let duration = set.estimatedDuration,
               !range.contains(duration)
            {
                return false
            }

            // Component types filter
            if !filters.componentTypes.isEmpty
            {
                let setComponentTypes = Set(set.components.map { $0.type })
                if !filters.componentTypes.isSubset(of: setComponentTypes)
                {
                    return false
                }
            }

            // Search text filter
            if !filters.searchText.isEmpty
            {
                let searchLower = filters.searchText.lowercased()
                let titleMatch = set.title.lowercased().contains(searchLower)
                let descriptionMatch = set.description?.lowercased().contains(searchLower) ?? false
                let strokeMatch = set.strokeDisplayLabelDetailed.lowercased().contains(searchLower)

                if !titleMatch, !descriptionMatch, !strokeMatch
                {
                    return false
                }
            }

            // Favorites filter
            if filters.showFavorites, !favoriteSetIds.contains(set.id)
            {
                return false
            }

            // Warmup filter
            if let hasWarmup = filters.hasWarmup
            {
                let setHasWarmup = set.components.contains
                { $0.type == .warmup }
                if hasWarmup != setHasWarmup
                {
                    return false
                }
            }

            // Cooldown filter
            if let hasCooldown = filters.hasCooldown
            {
                let setHasCooldown = set.components.contains
                { $0.type == .cooldown }
                if hasCooldown != setHasCooldown
                {
                    return false
                }
            }

            return true
        }
    }

    // MARK: - Filter Actions

    func updateSearchText(_ text: String)
    {
        var updatedFilters = activeFilters
        updatedFilters.searchText = text
        activeFilters = updatedFilters
    }

    func clearAllFilters()
    {
        activeFilters = SetFilters.defaultFilters
    }
    
    func clearSearch()
    {
        var updatedFilters = activeFilters
        updatedFilters.searchText = ""
        activeFilters = updatedFilters
    }

    func toggleFavorite(setId: UUID)
    {
        if favoriteSetIds.contains(setId)
        {
            favoriteSetIds.remove(setId)
        }
        else
        {
            favoriteSetIds.insert(setId)
        }
    }

    func isSetFavorite(setId: UUID) -> Bool
    {
        return favoriteSetIds.contains(setId)
    }

    // MARK: - Smart Recommendations

    func getSmartRecommendations(for userLevel: SwimSet.Difficulty, preferredDistance: DistanceRange) -> [SwimSet]
    {
        let smartFilters = SetFilters(
            strokes: preferredStroke.map { [$0] } ?? [],
            difficulty: userLevel,
            unit: preferredUnit,
            componentTypes: [],
            distanceRange: preferredDistance,
            durationRange: .any,
            searchText: "",
            showFavorites: false,
            hasWarmup: true,
            hasCooldown: true,
            isIMFilter: false
        )

        return filterSets(sampleSets, with: smartFilters)
            .shuffled()
            .prefix(3)
            .map { $0 }
    }

    // MARK: - Quick Filter Methods

    func isQuickFilterSelected(_ filterName: String) -> Bool
    {
        switch filterName
        {
        case "Favorites":
            return activeFilters.showFavorites
        case "Beginner":
            return activeFilters.difficulty == .beginner
        case "Intermediate":
            return activeFilters.difficulty == .intermediate
        case "Advanced":
            return activeFilters.difficulty == .advanced
        case "Freestyle":
            return activeFilters.strokes.contains(.freestyle)
        case "Backstroke":
            return activeFilters.strokes.contains(.backstroke)
        case "Breaststroke":
            return activeFilters.strokes.contains(.breaststroke)
        case "Butterfly":
            return activeFilters.strokes.contains(.butterfly)
        case "IM":
            return activeFilters.isIMFilter
        default:
            return false
        }
    }

    func applyQuickFilter(_ filterName: String)
    {
        var updatedFilters = activeFilters
        
        switch filterName
        {
        case "Favorites":
            updatedFilters.showFavorites.toggle()
        case "Beginner":
            updatedFilters.difficulty = updatedFilters.difficulty == .beginner ? nil : .beginner
        case "Intermediate":
            updatedFilters.difficulty = updatedFilters.difficulty == .intermediate ? nil : .intermediate
        case "Advanced":
            updatedFilters.difficulty = updatedFilters.difficulty == .advanced ? nil : .advanced
        case "Freestyle":
            toggleStroke(.freestyle)
            return // toggleStroke handles the update
        case "Backstroke":
            toggleStroke(.backstroke)
            return // toggleStroke handles the update
        case "Breaststroke":
            toggleStroke(.breaststroke)
            return // toggleStroke handles the update
        case "Butterfly":
            toggleStroke(.butterfly)
            return // toggleStroke handles the update
        case "IM":
            updatedFilters.isIMFilter.toggle()
            if updatedFilters.isIMFilter
            {
                updatedFilters.strokes.removeAll()
            }
        default:
            return
        }
        
        activeFilters = updatedFilters
    }
    
    private func toggleStroke(_ stroke: SwimStroke)
    {
        var updatedFilters = activeFilters
        
        // If IM is active, turn it off when selecting individual strokes
        if updatedFilters.isIMFilter
        {
            updatedFilters.isIMFilter = false
        }
        
        if updatedFilters.strokes.contains(stroke)
        {
            updatedFilters.strokes.remove(stroke)
        }
        else
        {
            updatedFilters.strokes.insert(stroke)
        }
        
        // Auto-select IM if all 4 strokes are selected
        let allStrokes: Set<SwimStroke> = [.freestyle, .backstroke, .breaststroke, .butterfly]
        if updatedFilters.strokes == allStrokes
        {
            updatedFilters.strokes.removeAll()
            updatedFilters.isIMFilter = true
        }
        
        activeFilters = updatedFilters
    }

    // MARK: - Statistics

    var filterStatistics: (total: Int, filtered: Int, percentage: Double)
    {
        let total = sampleSets.count
        let filtered = filteredSets.count
        let percentage = total > 0 ? (Double(filtered) / Double(total)) * 100 : 0
        return (total, filtered, percentage)
    }
}

