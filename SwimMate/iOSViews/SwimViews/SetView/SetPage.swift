// SwimMate/iOSViews/SwimViews/SetView/SetPage.swift

import SwiftUI

struct SetPage: View {
    @EnvironmentObject var manager: Manager
    @EnvironmentObject var watchOSManager: WatchConnector
    
    @State private var showingFilter = false
    @State private var showingSearch = false
    
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
                        SetPageHeroSection(
                            showingSearch: $showingSearch,
                            showingFilter: $showingFilter,
                            hasActiveFilters: hasActiveFilters
                        )
                        
                        // Quick Filter Chips
                        QuickFilterChipsSection()
                            .environmentObject(manager)
                        
                        // Recommended Sets Section
                        if !manager.recommendedSets.isEmpty {
                            RecommendedSetsSection()
                                .environmentObject(manager)
                                .environmentObject(watchOSManager)
                        }
                        
                        // Current Filter Summary
                        FilterSummarySection(hasActiveFilters: hasActiveFilters)
                            .environmentObject(manager)
                        
                        // Main Sets Grid
                        SetsGridSection()
                            .environmentObject(manager)
                            .environmentObject(watchOSManager)
                        
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
    
    // MARK: - Helper Properties
    private var hasActiveFilters: Bool {
        manager.activeFilters != Manager.SetFilters.defaultFilters
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