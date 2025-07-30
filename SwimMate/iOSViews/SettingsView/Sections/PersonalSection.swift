// SwimMate/iOSViews/SettingsView/Sections/PersonalSection.swift

import SwiftUI

struct PersonalSection: View
{
    var body: some View
    {
        Section(header: Text("Personal"))
        {
            NavigationLink(destination: PreferencesView())
            {
                SettingsRow(icon: "person.circle.fill", title: "Profile & Preferences", color: .blue)
            }

            NavigationLink(destination: GoalsSettingsView())
            {
                SettingsRow(icon: "target", title: "Goals & Pool", color: .green)
            }
        }
    }
}

#Preview
{
    Form
    {
        PersonalSection()
    }
}
