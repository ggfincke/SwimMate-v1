
// SwimMate/iOSViews/SwimViews/SetView/SetPage.swift

import SwiftUI

struct SetPage: View
{
    @EnvironmentObject var manager: Manager
    @EnvironmentObject var watchOSManager: WatchConnector

    @State private var showingFilter = false
    @State private var showingSearch = false

    var body: some View
    {
        ZStack
        {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.cyan.opacity(0.05)],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()

            ScrollView
            {
                LazyVStack(spacing: 24)
                {
                    // Hero Header
                    SetPageHeroSection(
                        showingSearch: $showingSearch,
                        showingFilter: $showingFilter,
                        hasActiveFilters: hasActiveFilters
                    )

                    // Quick Filter Chips
                    QuickFilterChipsSection()
                        .environmentObject(manager)

                    // Recommended Sets Section (hidden during search)
                    if !manager.recommendedSets.isEmpty && !manager.isSearchActive
                    {
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
        .sheet(isPresented: $showingFilter)
        {
            FilterSheetView()
                .environmentObject(manager)
        }
        .sheet(isPresented: $showingSearch)
        {
            SearchSheetView()
                .environmentObject(manager)
        }
    }

    // MARK: - Helper Properties

    private var hasActiveFilters: Bool
    {
        manager.activeFilters != Manager.SetFilters.defaultFilters
    }
}

// MARK: - Preview

#Preview
{
    SetPage()
        .environmentObject(Manager())
        .environmentObject(WatchConnector())
}
