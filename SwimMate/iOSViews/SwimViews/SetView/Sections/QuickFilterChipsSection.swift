// SwimMate/iOSViews/SwimViews/SetView/Sections/QuickFilterChipsSection.swift

import SwiftUI

struct QuickFilterChipsSection: View {
    @EnvironmentObject var manager: Manager
    
    // Quick filter presets
    private let quickFilters: [(String, String, () -> Manager.SetFilters)] = [
        ("All", "circle.grid.2x2", { Manager.SetFilters.defaultFilters }),
        ("Beginner", "person.fill", { 
            var filters = Manager.SetFilters.defaultFilters
            filters.difficulty = .beginner
            return filters
        }),
        ("Sprint", "bolt.fill", { 
            var filters = Manager.SetFilters.defaultFilters
            filters.distanceRange = .short
            filters.durationRange = .quick
            return filters
        }),
        ("Endurance", "figure.walk", { 
            var filters = Manager.SetFilters.defaultFilters
            filters.distanceRange = .long
            filters.durationRange = .long
            return filters
        }),
        ("Technique", "gear", { 
            var filters = Manager.SetFilters.defaultFilters
            filters.componentTypes = [.drill]
            return filters
        }),
        ("Favorites", "heart.fill", { 
            var filters = Manager.SetFilters.defaultFilters
            filters.showFavorites = true
            return filters
        })
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(quickFilters.enumerated()), id: \.offset) { index, filter in
                    QuickFilterChip(
                        title: filter.0,
                        icon: filter.1,
                        isSelected: isQuickFilterSelected(index),
                        action: { applyQuickFilter(filter.2()) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func isQuickFilterSelected(_ index: Int) -> Bool {
        let filterToCheck = quickFilters[index].2()
        return manager.activeFilters == filterToCheck
    }
    
    private func applyQuickFilter(_ filters: Manager.SetFilters) {
        withAnimation(.easeInOut(duration: 0.3)) {
            manager.activeFilters = filters
        }
    }
}