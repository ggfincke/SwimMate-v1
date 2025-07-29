// SwimMate/iOSViews/SettingsView/Sections/QuickActionsSection.swift

import SwiftUI

struct QuickSettingsSection: View
{
    @EnvironmentObject var manager: Manager

    var body: some View
    {
        Section(header: Text("Quick Actions"))
        {
            Button(action: {
                triggerHapticFeedback()
            })
            {
                SettingsRow(icon: "arrow.clockwise", title: "Sync Data", color: .orange)
            }
            .foregroundColor(.primary)

            Button(action: {
                openAppInAppStore()
            })
            {
                SettingsRow(icon: "star.fill", title: "Rate App", color: .yellow)
            }
            .foregroundColor(.primary)
        }
    }

    private func triggerHapticFeedback()
    {
        if manager.hapticFeedback
        {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
        // In a real app, this would trigger a data sync
    }

    private func openAppInAppStore()
    {
        if let url = URL(string: "https://apps.apple.com/app/swimmate")
        {
            UIApplication.shared.open(url)
        }
    }
}

#Preview
{
    Form
    {
        QuickSettingsSection()
    }
    .environmentObject(Manager())
}
