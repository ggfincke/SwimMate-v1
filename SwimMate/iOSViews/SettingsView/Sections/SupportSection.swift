// SwimMate/iOSViews/SettingsView/Sections/SupportSection.swift

import SwiftUI

struct SupportSection: View
{
    var body: some View
    {
        Section(header: Text("Support"))
        {
            Button(action: {
                sendSupportEmail()
            })
            {
                SettingsRow(icon: "envelope.fill", title: "Contact Support", color: .blue)
            }
            .foregroundColor(.primary)

            Button(action: {
                openUserGuide()
            })
            {
                SettingsRow(icon: "book.fill", title: "User Guide", color: .indigo)
            }
            .foregroundColor(.primary)
        }
    }

    private func sendSupportEmail()
    {
        if let url = URL(string: "mailto:support@swimmate.app")
        {
            UIApplication.shared.open(url)
        }
    }

    private func openUserGuide()
    {
        if let url = URL(string: "https://swimmate.app/guide")
        {
            UIApplication.shared.open(url)
        }
    }
}

#Preview
{
    Form
    {
        SupportSection()
    }
}
