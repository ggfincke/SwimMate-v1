// WatchRootView.swift

import SwiftUI
import HealthKit

// root view for watch app
struct WatchRootView: View
{
    @EnvironmentObject var manager: WatchManager
    @EnvironmentObject var iosManager: iOSWatchConnector
    @State private var showSettings = false
    @State private var activeButton: String? = nil
    @State private var showHealthKitAlert = false

    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 16)
            {
                // app title w/ logo
                HStack(spacing: 6)
                {
                    Image(systemName: "figure.pool.swim")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.blue)
                    
                    Text("SwimMate")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
                .padding(.top, 8)
                .padding(.bottom, 4)
                
                // HealthKit status banner (if not authorized)
                if manager.authorizationRequested && !manager.healthKitAuthorized {
                    healthKitWarningBanner
                }
                
                // line to divide buttons
                Divider()
                    .padding(.horizontal)
                
                // main nav buttons
                VStack(spacing: 14)
                {
                    // quick start
                    mainButton(
                        label: "Quick Start",
                        icon: "bolt.fill",
                        tint: manager.canStartWorkout ? .green : .gray,
                        buttonId: "quick",
                        isEnabled: manager.canStartWorkout
                    )
                    {
                        if manager.canStartWorkout {
                            withAnimation
                            {
                                activeButton = "quick"
                            }
                            
                            // button animation effect
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                            {
                                manager.path.append(NavState.workoutSetup)
                                activeButton = nil
                            }
                        } else {
                            showHealthKitAlert = true
                        }
                    }
                    
                    // set goal workout
                    mainButton(
                        label: "Set Goal",
                        icon: "target",
                        tint: manager.canStartWorkout ? .blue : .gray,
                        buttonId: "goal",
                        isEnabled: manager.canStartWorkout
                    )
                    {
                        if manager.canStartWorkout {
                            withAnimation
                            {
                                activeButton = "goal"
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                            {
                                manager.path.append(NavState.goalWorkoutSetup)
                                activeButton = nil
                            }
                        } else {
                            showHealthKitAlert = true
                        }
                    }
                    
                    // import set from iOS
                    mainButton(
                        label: "Import Set",
                        icon: "square.and.arrow.down.fill",
                        tint: .orange,
                        buttonId: "import",
                        isEnabled: true
                    )
                    {
                        withAnimation
                        {
                            activeButton = "import"
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                        {
                            manager.path.append(NavState.importSetView)
                            activeButton = nil
                        }
                    }
                    
                    // settings button (doesn't navigate away)
                    Button(action: {
                        withAnimation
                        {
                            activeButton = "settings"
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                        {
                            showSettings = true
                            activeButton = nil
                        }
                    })
                    {
                        HStack(spacing: 8)
                        {
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
        .sheet(isPresented: $showSettings)
        {
            SettingsView()
        }
        .alert("HealthKit Access Required", isPresented: $showHealthKitAlert) {
            Button("Open Settings") {
                showSettings = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("SwimMate needs HealthKit access to track your swimming workouts. Please enable access in Settings.")
        }
    }
    
    // HealthKit warning banner
    private var healthKitWarningBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.system(size: 14))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("HealthKit Access Required")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Enable in Settings to track workouts")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Fix") {
                showSettings = true
            }
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.1))
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 12)
    }
    
    // custom button builder
    private func mainButton(label: String, icon: String, tint: Color, buttonId: String, isEnabled: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action)
        {
            HStack(spacing: 10)
            {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .opacity(0.7)
            }
            .foregroundColor(isEnabled ? .white : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                activeButton == buttonId ? tint.opacity(0.8) : tint
            )
            .cornerRadius(12)
            .scaleEffect(activeButton == buttonId ? 0.95 : 1)
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
    
    // stat item component
    private func statItem(value: String, label: String) -> some View
    {
        VStack(spacing: 2)
        {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // format distance for display
    private func formatDistance(_ meters: Double) -> String
    {
        if manager.poolUnit == "yards"
        {
            let yards = meters * 1.09361
            return "\(Int(yards)) yd"
        }
        else
        {
            return "\(Int(meters)) m"
        }
    }
}

// preview
#Preview
{
    WatchRootView()
        .environmentObject(WatchManager())
        .environmentObject(iOSWatchConnector())
}
