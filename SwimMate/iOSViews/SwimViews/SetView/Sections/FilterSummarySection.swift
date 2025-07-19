// SwimMate/iOSViews/SwimViews/SetView/Sections/FilterSummarySection.swift

import SwiftUI

struct FilterSummarySection: View
{
    @EnvironmentObject var manager: Manager
    let hasActiveFilters: Bool
    
    @ViewBuilder var body: some View
    {
        if hasActiveFilters 
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

#Preview {
    FilterSummarySection(hasActiveFilters: true)
        .environmentObject(Manager())
}