// SwimMate/iOSViews/Components/Display/SettingsRow.swift

import SwiftUI

struct SettingsRow: View
{
    let icon: String
    let title: String
    let color: Color

    var body: some View
    {
        HStack(spacing: 12)
        {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .cornerRadius(6)

            Text(title)
                .font(.body)

            Spacer()
        }
    }
}

#Preview
{
    SettingsRow(icon: "person.circle.fill", title: "Profile & Preferences", color: .blue)
}