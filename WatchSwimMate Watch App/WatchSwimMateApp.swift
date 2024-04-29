//
//  WatchSwimMateApp.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/26/24.
//

import SwiftUI
import HealthKit

@main
struct WatchSwimMate_Watch_App: App
{
    @StateObject private var watchManager = WatchManager()

    @SceneBuilder var body: some Scene
    {
        WindowGroup
        {
            WatchRootView()
//            NavigationView
//            {
//                WatchRootView()
//            }
            .sheet(isPresented: $watchManager.showingSummaryView)
            {
                SwimmingSummaryView()
            }
            .environmentObject(watchManager)
            .environmentObject(iOSWatchConnector())  


        }
    }
}
