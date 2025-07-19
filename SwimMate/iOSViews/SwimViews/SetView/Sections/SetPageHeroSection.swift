// SwimMate/iOSViews/SwimViews/SetView/Sections/SetPageHeroSection.swift

import SwiftUI

struct SetPageHeroSection: View
{
    @Binding var showingSearch: Bool
    @Binding var showingFilter: Bool
    let hasActiveFilters: Bool
    
    var body: some View
    {
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
}

#Preview {
    SetPageHeroSection(
        showingSearch: .constant(false),
        showingFilter: .constant(false),
        hasActiveFilters: false
    )
}