// SwimMate/iOSViews/HomeView/Sections/ProgressChartsSection.swift

import SwiftUI

struct ProgressChartsSection: View {
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            BeautifulDistanceChart()
                .environmentObject(manager)
        }
    }
}

#Preview {
    ProgressChartsSection()
        .environmentObject(Manager())
}