// SwimMate/iOSViews/SettingsView/DataPrivacySettingsView.swift

import SwiftUI

struct DataPrivacySettingsView: View {
    @EnvironmentObject var manager: Manager
    @State private var showingDeleteAlert = false
    @State private var showingExportSheet = false
    
    var body: some View {
        Form {
            Section(header: Text("Data Collection")) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("SwimMate collects the following data:")
                        .font(.headline)
                    
                    DataItemRow(icon: "figure.pool.swim", title: "Workout Data", description: "Swimming sessions, duration, distance, strokes")
                    DataItemRow(icon: "heart.fill", title: "Health Data", description: "Heart rate, calories burned (via HealthKit)")
                    DataItemRow(icon: "person.fill", title: "Personal Info", description: "Name, preferences, goals")
                    DataItemRow(icon: "chart.bar.fill", title: "Usage Analytics", description: "App usage patterns (anonymous)")
                }
                .padding(.vertical, 8)
            }
            
            Section(header: Text("Data Usage")) {
                Toggle("Share Anonymous Analytics", isOn: .constant(false))
                    .disabled(true)
                
                Text("Help improve SwimMate by sharing anonymous usage data")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Toggle("Crash Reports", isOn: .constant(true))
                    .disabled(true)
                
                Text("Send crash reports to help fix bugs")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Data Storage")) {
                HStack {
                    Text("Local Storage")
                    Spacer()
                    Text(getLocalStorageInfo())
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("iCloud Sync")
                    Spacer()
                    Text(manager.autoSync ? "Enabled" : "Disabled")
                        .foregroundColor(manager.autoSync ? .green : .orange)
                }
                
                HStack {
                    Text("HealthKit Integration")
                    Spacer()
                    Text(manager.permission ? "Connected" : "Not Connected")
                        .foregroundColor(manager.permission ? .green : .red)
                }
            }
            
            Section(header: Text("Data Export")) {
                Button("Export All Data") {
                    showingExportSheet = true
                }
                .disabled(!manager.dataExportEnabled)
                
                if !manager.dataExportEnabled {
                    Text("Data export is disabled in App Settings")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("Export your workout data in CSV format")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Data Deletion")) {
                Button("Delete All Workout Data") {
                    showingDeleteAlert = true
                }
                .foregroundColor(.red)
                
                Text("⚠️ This action cannot be undone")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Section(header: Text("Privacy Policy")) {
                Button("View Privacy Policy") {
                    openPrivacyPolicy()
                }
                .foregroundColor(.blue)
                
                Button("View Terms of Service") {
                    openTermsOfService()
                }
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("Data & Privacy")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete All Data", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("This will permanently delete all your workout data. This action cannot be undone.")
        }
        .sheet(isPresented: $showingExportSheet) {
            DataExportSheet()
                .environmentObject(manager)
        }
    }
    
    private func getLocalStorageInfo() -> String {
        let workoutCount = manager.swims.count
        let estimatedSize = workoutCount * 2 // KB per workout estimate
        
        if estimatedSize < 1024 {
            return "\(estimatedSize) KB"
        } else {
            return String(format: "%.1f MB", Double(estimatedSize) / 1024)
        }
    }
    
    private func deleteAllData() {
        manager.swims.removeAll()
        manager.favoriteSetIds.removeAll()
        manager.totalDistance = 0
        manager.averageDistance = 0
        manager.totalCalories = 0
        manager.averageCalories = 0
        manager.updateStore()
        
        if manager.hapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        }
    }
    
    private func openPrivacyPolicy() {
        // In a real app, this would open the privacy policy URL
        if let url = URL(string: "https://swimmate.app/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfService() {
        // In a real app, this would open the terms of service URL
        if let url = URL(string: "https://swimmate.app/terms") {
            UIApplication.shared.open(url)
        }
    }
}

struct DataItemRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct DataExportSheet: View {
    @EnvironmentObject var manager: Manager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                
                Text("Export Workout Data")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Your data will be exported in CSV format including all workout details, dates, and performance metrics.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Export includes:")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("\(manager.swims.count) workout sessions")
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Distance and duration data")
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Stroke and performance metrics")
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button("Export Data") {
                    exportData()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
    
    private func exportData() {
        // In a real app, this would generate and share a CSV file
        if manager.hapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
        dismiss()
    }
}

#Preview {
    DataPrivacySettingsView()
        .environmentObject(Manager())
}