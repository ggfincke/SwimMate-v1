// Settings View implementation

import SwiftUI
import HealthKit

// settings
struct SettingsView: View
{
    @EnvironmentObject var manager: WatchManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        List
        {
            // HealthKit Section
            Section(header: Text("Health & Privacy"))
            {
                healthKitStatusRow
                
                if manager.authorizationRequested {
                    Button("Re-request HealthKit Access")
                    {
                        manager.requestAuthorization()
                    }
                    .foregroundColor(.blue)
                }
                else
                {
                    Button("Request HealthKit Access")
                    {
                        manager.requestAuthorization()
                    }
                    .foregroundColor(.blue)
                }
            }
            
            Section(header: Text("Pool Settings"))
            {
                Picker("Default Unit", selection: $manager.poolUnit)
                {
                    Text("Meters").tag("meters")
                    Text("Yards").tag("yards")
                }
                
                Picker("Default Length", selection: $manager.poolLength)
                {
                    Text("25").tag(25.0)
                    Text("50").tag(50.0)
                    Text("33.33").tag(33.33)
                }
            }
            
            Section
            {
                Button("Done")
                {
                    dismiss()
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    // HealthKit status row
    private var healthKitStatusRow: some View
    {
        HStack
        {
            Image(systemName: healthKitStatusIcon)
                .foregroundColor(healthKitStatusColor)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2)
            {
                Text("HealthKit Access")
                    .font(.system(size: 14, weight: .medium))
                
                Text(healthKitStatusText)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
    
    // HealthKit status helpers
    private var healthKitStatusIcon: String
    {
        if !manager.authorizationRequested
        {
            return "questionmark.circle"
        }
        else if manager.healthKitAuthorized
        {
            return "checkmark.circle.fill"
        }
        else
        {
            return "exclamationmark.triangle.fill"
        }
    }
    
    private var healthKitStatusColor: Color
    {
        if !manager.authorizationRequested
        {
            return .orange
        }
        else if manager.healthKitAuthorized
        {
            return .green
        }
        else
        {
            return .red
        }
    }
    
    private var healthKitStatusText: String
    {
        if !HKHealthStore.isHealthDataAvailable()
        {
            return "Not available on this device"
        }
        else if !manager.authorizationRequested
        {
            return "Not requested"
        }
        else if manager.healthKitAuthorized
        {
            return "Authorized - Ready to track workouts"
        }
        else
        {
            return "Access denied - Cannot track workouts"
        }
    }
}
