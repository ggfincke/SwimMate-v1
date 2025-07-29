// SwimMate/iOSViews/SettingsView/SettingsView.swift

import SwiftUI

struct SettingsView: View
{
    @EnvironmentObject var manager: Manager

    var body: some View
    {
        List
        {
            PersonalSection()
            AppExperienceSection()
            DataPrivacySection()
            QuickSettingsSection()
            SupportSection()
        }
        .navigationTitle("Settings")
        .listStyle(GroupedListStyle())
    }
}

#Preview
{
    SettingsView()
        .environmentObject(Manager())
}
