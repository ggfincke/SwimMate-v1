// WatchRootView

import SwiftUI

struct WatchRootView: View {
    @EnvironmentObject var manager: WatchManager
    @EnvironmentObject var iosManager: iOSWatchConnector
    @State private var showSettings = false
    @State private var activeButton: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 16)
            {
                // app title w/ logo
                HStack(spacing: 6) {
                    Image(systemName: "figure.pool.swim")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.blue)
                    
                    Text("SwimMate")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
                .padding(.top, 8)
                .padding(.bottom, 4)
                
                // line to divide buttons
                Divider()
                    .padding(.horizontal)
                
                // main nav buttons
                VStack(spacing: 14) {
                    // quick start
                    mainButton(
                        label: "Quick Start",
                        icon: "bolt.fill",
                        tint: .green,
                        buttonId: "quick"
                    ) {
                        withAnimation {
                            activeButton = "quick"
                        }
                        
                        // button animation effect
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            manager.path.append(NavState.workoutSetup)
                            activeButton = nil
                        }
                    }
                    
                    // set goal workout
                    mainButton(
                        label: "Set Goal",
                        icon: "target",
                        tint: .blue,
                        buttonId: "goal"
                    ) {
                        withAnimation {
                            activeButton = "goal"
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            manager.path.append(NavState.goalWorkoutSetup)
                            activeButton = nil
                        }
                    }
                    
                    // import set from iOS
                    mainButton(
                        label: "Import Set",
                        icon: "square.and.arrow.down.fill",
                        tint: .orange,
                        buttonId: "import"
                    ) {
                        withAnimation {
                            activeButton = "import"
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            manager.path.append(NavState.importSetView)
                            activeButton = nil
                        }
                    }
                    
                    // settings button (doesn't navigate away)
                    Button(action: {
                        withAnimation {
                            activeButton = "settings"
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showSettings = true
                            activeButton = nil
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "gear")
                                .font(.system(size: 16))
                            Text("Settings")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            activeButton == "settings" ? Color.gray.opacity(0.8) : Color.gray
                        )
                        .cornerRadius(12)
                        .scaleEffect(activeButton == "settings" ? 0.95 : 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 12)
            }
            .padding(.bottom, 12)
        }
        // show settings on click 
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    // custom button builder
    private func mainButton(label: String, icon: String, tint: Color, buttonId: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .opacity(0.7)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                activeButton == buttonId ? tint.opacity(0.8) : tint
            )
            .cornerRadius(12)
            .scaleEffect(activeButton == buttonId ? 0.95 : 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // stat item component
    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // format distance for display
    private func formatDistance(_ meters: Double) -> String {
        if manager.poolUnit == "yards" {
            let yards = meters * 1.09361
            return "\(Int(yards)) yd"
        } else {
            return "\(Int(meters)) m"
        }
    }
}

// preview
#Preview {
    WatchRootView()
        .environmentObject(WatchManager())
        .environmentObject(iOSWatchConnector())
}
