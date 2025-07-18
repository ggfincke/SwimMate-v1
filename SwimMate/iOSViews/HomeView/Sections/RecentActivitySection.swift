// SwimMate/iOSViews/HomeView/Sections/RecentActivitySection.swift

import SwiftUI

struct RecentActivitySection: View {
    @EnvironmentObject var manager: Manager
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Swims")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: { selectedTab = 2 }) {
                    Text("View All")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            if recentSwims.isEmpty {
                EmptyRecentActivityView()
            } else {
                VStack(spacing: 12) {
                    ForEach(recentSwims.prefix(3)) { swim in
                        NavigationLink(destination: WorkoutView(swim: swim)) {
                            BeautifulSwimRow(swim: swim)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    private var recentSwims: [Swim] {
        return manager.swims.sorted(by: { $0.date > $1.date })
    }
}

#Preview {
    RecentActivitySection(selectedTab: .constant(0))
        .environmentObject(Manager())
}