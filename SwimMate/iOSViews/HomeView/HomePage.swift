// SwimMate/iOSViews/HomeView/HomePage.swift

import SwiftUI
import Charts

// HomePage
struct HomePage: View {
    @EnvironmentObject var manager: Manager
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // weekly summary card
                    WeeklySummaryCard()
                        .environmentObject(manager)
                    
                    // recent activity card
                    RecentActivityCard()
                        .environmentObject(manager)
                    
                    // distance chart
                    DistanceChartCard()
                        .environmentObject(manager)
                }
                .padding()
            }
            .navigationTitle("SwimMate")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
    }
}

#Preview {
    HomePage()
        .environmentObject(Manager())
}
