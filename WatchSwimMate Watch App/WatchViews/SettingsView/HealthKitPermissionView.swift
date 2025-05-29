// HealthKitPermissionView.swift

import SwiftUI
import HealthKit

// health kit permissions for watch app
struct HealthKitPermissionView: View 
{
    @Environment(WatchManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    @State private var isRequesting = false
    
    var body: some View 
    {
        ScrollView {
            VStack(spacing: 20) 
            {
                // header
                VStack(spacing: 12) 
                {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    
                    Text("HealthKit Access")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text("SwimMate needs access to HealthKit to track your swimming workouts and save them to the Health app.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 16)
                
                // permissions we need
                VStack(spacing: 12) 
                {
                    Text("We'll request access to:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 8) 
                    {
                        permissionRow(
                            icon: "figure.pool.swim",
                            title: "Swimming Workouts",
                            description: "Track and save swim sessions"
                        )
                        
                        permissionRow(
                            icon: "heart.fill",
                            title: "Heart Rate",
                            description: "Monitor workout intensity"
                        )
                        
                        permissionRow(
                            icon: "flame.fill",
                            title: "Active Calories",
                            description: "Track energy burned"
                        )
                    }
                }
                
                Spacer()
                
                // action button
                if isRequesting
                {
                    HStack
                    {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Requesting...")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 16)
                }
                else
                {
                    VStack(spacing: 12)
                    {
                        Button(action: requestPermission)
                        {
                            Text("Allow HealthKit Access")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button("Maybe Later")
                        {
                            dismiss()
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationTitle("Health Access")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: manager.healthKitAuthorized) 
        { _, newValue in
            // auto-dismiss if we get auth
            if newValue 
            {
                dismiss()
            }
        }
    }
    
    // permission row
    private func permissionRow(icon: String, title: String, description: String) -> some View
    {
        HStack(spacing: 10)
        {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2)
            {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    // request permission action
    private func requestPermission()
    {
        isRequesting = true
        WKInterfaceDevice.current().play(.click)
        
        manager.requestAuthorization()
        
        // auto-dismiss after a short delay to allow the system dialog to appear
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
        {
            isRequesting = false
            dismiss()
        }
    }
}

#Preview
{
    HealthKitPermissionView()
        .environment(WatchManager())
}
