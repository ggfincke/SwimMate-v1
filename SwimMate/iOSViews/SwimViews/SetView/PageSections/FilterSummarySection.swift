// SwimMate/iOSViews/SwimViews/SetView/PageSections/FilterSummarySection.swift

import SwiftUI

struct FilterSummarySection: View
{
    @EnvironmentObject var manager: Manager
    let hasActiveFilters: Bool

    @ViewBuilder var body: some View
    {
        // Show search indicator if search is active
        if manager.isSearchActive
        {
            HStack
            {
                HStack(spacing: 8)
                {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)

                    VStack(alignment: .leading, spacing: 2)
                    {
                        Text("Searching for:")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)

                        Text("\"\(manager.activeFilters.searchText)\"")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }

                Spacer()

                Button(action:
                    {
                        withAnimation(.easeInOut(duration: 0.3))
                        {
                            manager.clearSearch()
                        }
                    })
                {
                    HStack(spacing: 4)
                    {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Clear")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(16)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        // Show regular filters if not searching but other filters are active
        else if hasActiveFilters
        {
            HStack
            {
                VStack(alignment: .leading, spacing: 4)
                {
                    Text("Active Filters")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)

                    Text(manager.filterSummary)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                }

                Spacer()

                Button(action:
                    {
                        withAnimation(.easeInOut(duration: 0.3))
                        {
                            manager.clearAllFilters()
                        }
                    })
                {
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
        }
        else
        {
            EmptyView()
        }
    }
}

#Preview
{
    FilterSummarySection(hasActiveFilters: true)
        .environmentObject(Manager())
}
