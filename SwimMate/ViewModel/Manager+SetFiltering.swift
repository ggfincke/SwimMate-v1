// SwimMate/ViewModel/Manager+SetFiltering.swift

import Foundation

// MARK: - Set Filtering Extension
extension Manager {
    
    // MARK: - Filter Options
    struct SetFilters: Equatable {
        var stroke: SwimStroke?
        var difficulty: SwimSet.Difficulty?
        var unit: MeasureUnit?
        var componentTypes: Set<SetComponent.ComponentType>
        var distanceRange: DistanceRange
        var durationRange: DurationRange
        var searchText: String
        var showFavorites: Bool
        var hasWarmup: Bool?
        var hasCooldown: Bool?
        
        static let defaultFilters = SetFilters(
            stroke: nil,
            difficulty: nil,
            unit: nil,
            componentTypes: [],
            distanceRange: .any,
            durationRange: .any,
            searchText: "",
            showFavorites: false,
            hasWarmup: nil,
            hasCooldown: nil
        )
    }
    
    enum DistanceRange: String, CaseIterable {
        case any = "Any"
        case short = "Short (< 1000)"
        case medium = "Medium (1000-2000)"
        case long = "Long (2000-3000)"
        case ultraLong = "Ultra Long (> 3000)"
        
        var range: ClosedRange<Int>? {
            switch self {
            case .any: return nil
            case .short: return 0...999
            case .medium: return 1000...2000
            case .long: return 2000...3000
            case .ultraLong: return 3001...Int.max
            }
        }
    }
    
    enum DurationRange: String, CaseIterable {
        case any = "Any"
        case quick = "Quick (< 20 min)"
        case moderate = "Moderate (20-40 min)"
        case long = "Long (40-60 min)"
        case extended = "Extended (> 60 min)"
        
        var range: ClosedRange<TimeInterval>? {
            switch self {
            case .any: return nil
            case .quick: return 0...1200 // 20 minutes
            case .moderate: return 1200...2400 // 20-40 minutes
            case .long: return 2400...3600 // 40-60 minutes
            case .extended: return 3600...TimeInterval.greatestFiniteMagnitude
            }
        }
    }
    
    // MARK: - Published Filter State
    
    // MARK: - Computed Properties
    var filteredSets: [SwimSet] {
        return filterSets(sampleSets, with: activeFilters)
    }
    
    var recommendedSets: [SwimSet] {
        let baseFilters = SetFilters(
            stroke: preferredStroke,
            difficulty: nil,
            unit: preferredUnit,
            componentTypes: [],
            distanceRange: .any,
            durationRange: .any,
            searchText: "",
            showFavorites: false,
            hasWarmup: nil,
            hasCooldown: nil
        )
        
        let recommended = filterSets(sampleSets, with: baseFilters)
        
        // Sort by difficulty preference (beginner first for new users)
        return recommended.sorted { set1, set2 in
            let difficultyOrder: [SwimSet.Difficulty] = [.beginner, .intermediate, .advanced]
            let index1 = difficultyOrder.firstIndex(of: set1.difficulty) ?? 0
            let index2 = difficultyOrder.firstIndex(of: set2.difficulty) ?? 0
            return index1 < index2
        }.prefix(5).map { $0 }
    }
    
    var filterSummary: String {
        var components: [String] = []
        
        if let stroke = activeFilters.stroke {
            components.append(stroke.description)
        }
        
        if let difficulty = activeFilters.difficulty {
            components.append(difficulty.rawValue)
        }
        
        if let unit = activeFilters.unit {
            components.append(unit.rawValue)
        }
        
        if activeFilters.distanceRange != .any {
            components.append(activeFilters.distanceRange.rawValue)
        }
        
        if activeFilters.durationRange != .any {
            components.append(activeFilters.durationRange.rawValue)
        }
        
        if !activeFilters.componentTypes.isEmpty {
            let types = activeFilters.componentTypes.map { $0.rawValue }.joined(separator: ", ")
            components.append(types)
        }
        
        if activeFilters.showFavorites {
            components.append("Favorites")
        }
        
        if let hasWarmup = activeFilters.hasWarmup {
            components.append(hasWarmup ? "Has Warmup" : "No Warmup")
        }
        
        if let hasCooldown = activeFilters.hasCooldown {
            components.append(hasCooldown ? "Has Cooldown" : "No Cooldown")
        }
        
        return components.isEmpty ? "All Sets" : components.joined(separator: " • ")
    }
    
    // MARK: - Filtering Logic
    private func filterSets(_ sets: [SwimSet], with filters: SetFilters) -> [SwimSet] {
        return sets.filter { set in
            // Stroke filter
            if let stroke = filters.stroke, set.primaryStroke != stroke {
                return false
            }
            
            // Difficulty filter
            if let difficulty = filters.difficulty, set.difficulty != difficulty {
                return false
            }
            
            // Unit filter
            if let unit = filters.unit, set.measureUnit != unit {
                return false
            }
            
            // Distance range filter
            if let range = filters.distanceRange.range, !range.contains(set.totalDistance) {
                return false
            }
            
            // Duration range filter
            if let range = filters.durationRange.range,
               let duration = set.estimatedDuration,
               !range.contains(duration) {
                return false
            }
            
            // Component types filter
            if !filters.componentTypes.isEmpty {
                let setComponentTypes = Set(set.components.map { $0.type })
                if !filters.componentTypes.isSubset(of: setComponentTypes) {
                    return false
                }
            }
            
            // Search text filter
            if !filters.searchText.isEmpty {
                let searchLower = filters.searchText.lowercased()
                let titleMatch = set.title.lowercased().contains(searchLower)
                let descriptionMatch = set.description?.lowercased().contains(searchLower) ?? false
                let strokeMatch = set.primaryStroke?.description.lowercased().contains(searchLower) ?? false
                
                if !titleMatch && !descriptionMatch && !strokeMatch {
                    return false
                }
            }
            
            // Favorites filter
            if filters.showFavorites && !favoriteSetIds.contains(set.id) {
                return false
            }
            
            // Warmup filter
            if let hasWarmup = filters.hasWarmup {
                let setHasWarmup = set.components.contains { $0.type == .warmup }
                if hasWarmup != setHasWarmup {
                    return false
                }
            }
            
            // Cooldown filter
            if let hasCooldown = filters.hasCooldown {
                let setHasCooldown = set.components.contains { $0.type == .cooldown }
                if hasCooldown != setHasCooldown {
                    return false
                }
            }
            
            return true
        }
    }
    
    // MARK: - Filter Actions
    func updateFilter<T: Equatable>(_ keyPath: WritableKeyPath<SetFilters, T>, to value: T) {
        activeFilters[keyPath: keyPath] = value
    }
    
    func clearAllFilters() {
        activeFilters = SetFilters.defaultFilters
    }
    
    func toggleFavorite(setId: UUID) {
        if favoriteSetIds.contains(setId) {
            favoriteSetIds.remove(setId)
        } else {
            favoriteSetIds.insert(setId)
        }
    }
    
    func isSetFavorite(setId: UUID) -> Bool {
        return favoriteSetIds.contains(setId)
    }
    
    // MARK: - Smart Recommendations
    func getSmartRecommendations(for userLevel: SwimSet.Difficulty, preferredDistance: DistanceRange) -> [SwimSet] {
        let smartFilters = SetFilters(
            stroke: preferredStroke,
            difficulty: userLevel,
            unit: preferredUnit,
            componentTypes: [],
            distanceRange: preferredDistance,
            durationRange: .any,
            searchText: "",
            showFavorites: false,
            hasWarmup: true,
            hasCooldown: true
        )
        
        return filterSets(sampleSets, with: smartFilters)
            .shuffled()
            .prefix(3)
            .map { $0 }
    }
    
    // MARK: - Statistics
    var filterStatistics: (total: Int, filtered: Int, percentage: Double) {
        let total = sampleSets.count
        let filtered = filteredSets.count
        let percentage = total > 0 ? (Double(filtered) / Double(total)) * 100 : 0
        return (total, filtered, percentage)
    }
}

