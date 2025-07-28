// SwimMate/iOSViews/SwimViews/SetView/Sections/QuickFilterChipsSection.swift

import SwiftUI

struct QuickFilterChipsSection: View
{
    @EnvironmentObject var manager: Manager

    // Quick filter presets
    private let quickFilters: [(String, String)] = [
        ("Favorites", "heart.fill"),
        ("Beginner", "person.fill"),
        ("Intermediate", "figure.walk"),
        ("Advanced", "figure.run"),
        ("Freestyle", "figure.pool.swim"),
        ("Backstroke", "arrow.up"),
        ("Breaststroke", "arrow.down"),
        ("Butterfly", "wing.left.and.wing.right"),
    ]

    var body: some View
    {
        ScrollView(.horizontal, showsIndicators: false)
        {
            HStack(spacing: 12)
            {
                ForEach(quickFilters, id: \.0)
                { filter in
                    QuickFilterChip(
                        title: filter.0,
                        icon: filter.1,
                        isSelected: manager.isQuickFilterSelected(filter.0),
                        action: { manager.applyQuickFilter(filter.0) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview
{
    QuickFilterChipsSection()
        .environmentObject(Manager())
}
