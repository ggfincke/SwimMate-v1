// SwimMate/iOSViews/SwimViews/SetView/SetPage.swift

import SwiftUI

struct SetPage: View {
    @EnvironmentObject var manager: Manager
    @EnvironmentObject var watchOSManager: WatchConnector
    
    @State private var showingFilter = false
    @State private var showingSearch = false
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
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
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.cyan.opacity(0.05)],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Hero Header
                        heroHeader
                        
                        // Quick Filter Chips
                        quickFilterChips
                        
                        // Recommended Sets Section
                        if !manager.recommendedSets.isEmpty {
                            recommendedSetsSection
                        }
                        
                        // Current Filter Summary
                        filterSummaryCard
                        
                        // Main Sets Grid
                        setsGridSection
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingFilter) {
            FilterSheetView()
                .environmentObject(manager)
        }
        .sheet(isPresented: $showingSearch) {
            SearchSheetView()
                .environmentObject(manager)
        }
    }
    
    // MARK: - Hero Header
    private var heroHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Swim Sets")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Choose your workout")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Search and Filter buttons
                HStack(spacing: 12) {
                    Button(action: { showingSearch = true }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                    Button(action: { showingFilter = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(hasActiveFilters ? Color.orange : Color.gray)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.top, 20)
    }
    
    private var hasActiveFilters: Bool {
        manager.activeFilters != Manager.SetFilters.defaultFilters
    }
    
    // MARK: - Quick Filter Chips
    private var quickFilterChips: some View {
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
    
    // MARK: - Recommended Sets Section
    private var recommendedSetsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recommended for You")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(manager.recommendedSets) { set in
                        NavigationLink(destination: SetDetailView(swimSet: set).environmentObject(watchOSManager)) {
                            RecommendedSetCard(
                                swimSet: set,
                                isFavorite: manager.isSetFavorite(setId: set.id),
                                toggleFavorite: { manager.toggleFavorite(setId: set.id) }
                            )
                            .frame(width: 280)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Filter Summary Card
    @ViewBuilder private var filterSummaryCard: some View {
        if hasActiveFilters {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Active Filters")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Text(manager.filterSummary)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        manager.clearAllFilters()
                    }
                }) {
                    Text("Clear")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(16)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        } else {
            EmptyView()
        }
    }
    
    // MARK: - Sets Grid Section
    private var setsGridSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("All Sets")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Spacer()
                
                Text("\(manager.filteredSets.count) sets")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            if manager.filteredSets.isEmpty {
                EmptyStateView()
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(manager.filteredSets) { set in
                        NavigationLink(destination: SetDetailView(swimSet: set).environmentObject(watchOSManager)) {
                            ModernSetCard(
                                swimSet: set,
                                isFavorite: manager.isSetFavorite(setId: set.id),
                                toggleFavorite: { manager.toggleFavorite(setId: set.id) }
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }

}

// MARK: - Helper Views

// MARK: - Quick Filter Chip
struct QuickFilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected ? Color.blue : Color(UIColor.systemGray6)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
            .shadow(color: .black.opacity(isSelected ? 0.15 : 0.05), radius: isSelected ? 6 : 2, x: 0, y: isSelected ? 3 : 1)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Recommended Set Card
struct RecommendedSetCard: View {
    let swimSet: SwimSet
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    private var difficultyColor: Color {
        switch swimSet.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(swimSet.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(swimSet.difficulty.rawValue.capitalized)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(difficultyColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(difficultyColor.opacity(0.15))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Stats
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Distance")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("\(swimSet.totalDistance)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Unit")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(swimSet.measureUnit.rawValue)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            // Description
            if let description = swimSet.description, !description.isEmpty {
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            // Components preview
            HStack {
                Text("\(swimSet.components.count) components")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let primaryStroke = swimSet.primaryStroke {
                    Text(primaryStroke.description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(difficultyColor.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Modern Set Card
struct ModernSetCard: View {
    let swimSet: SwimSet
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    private var difficultyColor: Color {
        switch swimSet.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with difficulty badge
            HStack {
                Text(swimSet.difficulty.rawValue.capitalized)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(difficultyColor)
                    .cornerRadius(6)
                
                Spacer()
                
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Title
            Text(swimSet.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Key metrics
            VStack(spacing: 6) {
                HStack {
                    Image(systemName: "ruler")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("\(swimSet.totalDistance) \(swimSet.measureUnit.rawValue)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("\(swimSet.components.count) components")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                if let primaryStroke = swimSet.primaryStroke {
                    HStack {
                        Image(systemName: "figure.pool.swim")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text(primaryStroke.description)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 180, alignment: .topLeading)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(difficultyColor.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Sets Found")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Try adjusting your filters or search terms")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    SetPage()
        .environmentObject(Manager())
        .environmentObject(WatchConnector())
}

