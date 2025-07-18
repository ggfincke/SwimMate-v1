// SwimMate/iOSViews/RootView.swift

import SwiftUI

struct RootView: View {
    @EnvironmentObject var manager: Manager
    @EnvironmentObject var watchOSManager: WatchConnector
    
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomePage(selectedTab: $selectedTab)
                .environmentObject(manager)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            SetPage()
                .environmentObject(manager)
                .environmentObject(watchOSManager)
                .tabItem {
                    Label("Sets", systemImage: "list.bullet")
                }
                .tag(1)
            
            LogbookView()
                .environmentObject(manager)
                .tabItem {
                    Label("Logbook", systemImage: "book.closed")
                }
                .tag(2)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(Manager())
        .environmentObject(WatchConnector())
        .onAppear {
            _ = HomePage(selectedTab: .constant(0))
        }
}
