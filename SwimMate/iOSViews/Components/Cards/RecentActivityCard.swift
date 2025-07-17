// SwimMate/iOSViews/Components/Cards/RecentActivityCard.swift

import SwiftUI

// recent activity card
struct RecentActivityCard: View {
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: LogbookView()) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            if recentSwims.isEmpty {
                Text("No recent swims")
                    .foregroundColor(.secondary)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(recentSwims) { swim in
                    NavigationLink(destination: WorkoutView(swim: swim)) {
                        RecentSwimRow(swim: swim)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if swim.id != recentSwims.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var recentSwims: [Swim] {
        return Array(manager.swims.sorted(by: { $0.date > $1.date }).prefix(3))
    }
}
