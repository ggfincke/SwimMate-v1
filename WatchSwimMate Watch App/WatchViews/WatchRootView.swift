// watchrootview

import SwiftUI

struct WatchRootView: View {
    @EnvironmentObject var manager: WatchManager
    @EnvironmentObject var iosManager: iOSWatchConnector
    @State private var showSettings = false

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 12) {
                Text("SwimMate")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                
                ActionButton(
                    label: "Quick Start",
                    icon: "bolt.fill",
                    tint: Color.green
                ) {
                    manager.path.append(NavState.workoutSetup)
                }
                
                ActionButton(
                    label: "Set Goal",
                    icon: "target",
                    tint: Color.blue
                ) {
                    manager.path.append(NavState.goalWorkoutSetup)
                }
                
                ActionButton(
                    label: "Import Set",
                    icon: "square.and.arrow.down.fill",
                    tint: Color.orange
                ) {
                    manager.path.append(NavState.importSetView)
                }
                
                ActionButton(
                    label: "Settings",
                    icon: "gear",
                    tint: Color.gray
                ) {
                    showSettings = true
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea(.container, edges: .top) 
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    WatchRootView()
        .environmentObject(WatchManager())
        .environmentObject(iOSWatchConnector())
}
