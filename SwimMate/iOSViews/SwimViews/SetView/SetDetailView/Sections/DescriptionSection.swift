// SwimMate/iOSViews/SwimViews/SetView/SetDetailView/Sections/DescriptionSection.swift

import SwiftUI

struct DescriptionSection: View
{
    let description: String

    var body: some View
    {
        VStack(alignment: .leading, spacing: 12)
        {
            Text("Description")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text(description)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview
{
    DescriptionSection(description: "A challenging set designed to improve endurance and pace. Focus on maintaining consistent stroke technique throughout the main set while building aerobic capacity.")
        .padding()
}