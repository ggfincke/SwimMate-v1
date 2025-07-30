// SwimMate/iOSViews/SettingsView/Sections/AppExperienceSection.swift

import SwiftUI

struct AppExperienceSection: View
{
    var body: some View
    {
        Section(header: Text("App Experience"))
        {
            NavigationLink(destination: NotificationsSettingsView())
            {
                SettingsRow(icon: "bell.fill", title: "Notifications", color: .red)
            }

            NavigationLink(destination: AppSettingsView())
            {
                SettingsRow(icon: "gear", title: "App Settings", color: .gray)
            }
        }
    }
}

#Preview
{
    Form
    {
        AppExperienceSection()
    }
}
