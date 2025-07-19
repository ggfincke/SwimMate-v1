// SwimMate/iOSViews/HomeView/HomePage.swift

import SwiftUI
import Charts

struct HomePage: View
{
    @EnvironmentObject var manager: Manager
    @Binding var selectedTab: Int
    @State private var showingSettings = false
    @State private var currentTime = Date()
    
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    init(selectedTab: Binding<Int>) 
    {
        self._selectedTab = selectedTab
    }
    
    var body: some View
    {
        NavigationStack 
        {
            ZStack 
            {
                // Beautiful gradient background
                LinearGradient(
                    colors: [Color.blue.opacity(0.08), Color.cyan.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) 
                {
                    LazyVStack(spacing: 24) 
                    {
                        // Hero Header
                        HomeHeroSection(showingSettings: $showingSettings, currentTime: currentTime)
                            .environmentObject(manager)
                        
                        // Quick Actions
                        QuickActionsSection(selectedTab: $selectedTab)
                        
                        // Stats Overview Cards
                        WeeklyStatsSection()
                            .environmentObject(manager)
                        
                        // Recent Activity
                        RecentActivitySection(selectedTab: $selectedTab)
                            .environmentObject(manager)
                        
                        // Progress Charts
                        ProgressChartsSection()
                            .environmentObject(manager)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onReceive(timer) 
            { _ in
                currentTime = Date()
            }
        }
        .sheet(isPresented: $showingSettings) 
        {
            NavigationStack 
        {
                SettingsView()
            }
        }
    }
}


#Preview 
{
    HomePage(selectedTab: .constant(0))
        .environmentObject(Manager())
}