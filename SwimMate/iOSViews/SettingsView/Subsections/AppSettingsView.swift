// SwimMate/iOSViews/SettingsView/Subsections/AppSettingsView.swift

import SwiftUI

struct AppSettingsView: View
{
    @EnvironmentObject var manager: Manager

    var body: some View
    {
        Form
        {
            Section(header: Text("Appearance"))
            {
                Picker("Theme", selection: $manager.appTheme)
                {
                    ForEach(AppTheme.allCases, id: \.self)
                    { theme in
                        HStack
                        {
                            themeIcon(for: theme)
                            Text(theme.displayName)
                        }
                        .tag(theme)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Text("Choose how the app looks")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section(header: Text("Charts & Data"))
            {
                Picker("Chart Display Period", selection: $manager.chartDisplayDays)
                {
                    Text("7 days").tag(7)
                    Text("30 days").tag(30)
                    Text("90 days").tag(90)
                    Text("6 months").tag(180)
                    Text("1 year").tag(365)
                }

                Text("Default time period for charts and graphs")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section(header: Text("Privacy & Data"))
            {
                Toggle("Privacy Mode", isOn: $manager.privacyMode)

                if manager.privacyMode
                {
                    Text("Hides personal data in screenshots and app switcher")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Toggle("Data Export", isOn: $manager.dataExportEnabled)

                if manager.dataExportEnabled
                {
                    Text("Allows exporting workout data to CSV or other formats")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Sync & Storage"))
            {
                Toggle("Auto Sync", isOn: $manager.autoSync)

                Text("Automatically sync data with HealthKit and iCloud")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack
                {
                    Text("Storage Used")
                    Spacer()
                    Text(calculateStorageUsed())
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("App Info"))
            {
                HStack
                {
                    Text("Version")
                    Spacer()
                    Text(getAppVersion())
                        .foregroundColor(.secondary)
                }

                HStack
                {
                    Text("Build")
                    Spacer()
                    Text(getBuildNumber())
                        .foregroundColor(.secondary)
                }

                HStack
                {
                    Text("Total Workouts")
                    Spacer()
                    Text("\(manager.swims.count)")
                        .foregroundColor(.blue)
                }
            }

            Section(header: Text("Actions"))
            {
                Button("Clear Cache")
                {
                    clearAppCache()
                }
                .foregroundColor(.orange)

                if manager.dataExportEnabled
                {
                    Button("Export Data")
                    {
                        exportWorkoutData()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("App Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func themeIcon(for theme: AppTheme) -> some View
    {
        switch theme
        {
        case .system:
            return Image(systemName: "circle.lefthalf.filled")
        case .light:
            return Image(systemName: "sun.max.fill")
        case .dark:
            return Image(systemName: "moon.fill")
        }
    }

    private func calculateStorageUsed() -> String
    {
        let swimsData = manager.swims.count * 1024 // Rough estimate
        let totalBytes = swimsData + 50000 // Add app overhead

        if totalBytes < 1024 * 1024
        {
            return "\(totalBytes / 1024) KB"
        }
        else
        {
            return String(format: "%.1f MB", Double(totalBytes) / (1024 * 1024))
        }
    }

    private func getAppVersion() -> String
    {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private func getBuildNumber() -> String
    {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    private func clearAppCache()
    {
        // In a real app, you would clear cached data here
        // For now, we'll just show a simple feedback
        if manager.hapticFeedback
        {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }

    private func exportWorkoutData()
    {
        // In a real app, this would export to CSV/JSON
        // For now, we'll just show feedback
        if manager.hapticFeedback
        {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
}

#Preview
{
    AppSettingsView()
        .environmentObject(Manager())
}
