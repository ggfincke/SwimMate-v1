// SwimMate/iOSViews/SwimViews/SetView/Sections/SetsGridSection.swift

import SwiftUI

struct SetsGridSection: View {
    @EnvironmentObject var manager: Manager
    @EnvironmentObject var watchOSManager: WatchConnector
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
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