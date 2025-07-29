// SwimMate/iOSViews/SettingsView/Sections/DataPrivacySection.swift

import SwiftUI

struct DataPrivacySection: View
{
    var body: some View
    {
        Section(header: Text("Data & Privacy"))
        {
            NavigationLink(destination: HealthKitPermissionView())
            {
                SettingsRow(icon: "heart.fill", title: "HealthKit", color: .pink)
            }

            NavigationLink(destination: DataPrivacySettingsView())
            {
                SettingsRow(icon: "lock.shield.fill", title: "Data & Privacy", color: .purple)
            }
        }
    }
}

#Preview
{
    Form
    {
        DataPrivacySection()
    }
}