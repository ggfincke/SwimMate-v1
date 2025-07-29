// SwimMate/iOSViews/SwimViews/SetView/PageSections/RecommendedSetsSection.swift

import SwiftUI

struct RecommendedSetsSection: View
{
    @EnvironmentObject var manager: Manager
    @EnvironmentObject var watchOSManager: WatchConnector

    var body: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            HStack
            {
                Text("Recommended for You")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false)
            {
                HStack(spacing: 16)
                {
                    ForEach(manager.recommendedSets)
                    { set in
                        NavigationLink(destination: SetDetailView(swimSet: set).environmentObject(watchOSManager))
                        {
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
}

#Preview
{
    RecommendedSetsSection()
        .environmentObject(Manager())
        .environmentObject(WatchConnector())
}
