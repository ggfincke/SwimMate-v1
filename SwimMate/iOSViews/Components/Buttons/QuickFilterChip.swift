// SwimMate/iOSViews/Components/Buttons/QuickFilterChip.swift

import SwiftUI

struct QuickFilterChip: View
{
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View
    {
        Button(action: action)
        {
            HStack(spacing: 8)
            {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected ? Color.blue : Color(UIColor.systemGray6)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
            .shadow(color: .black.opacity(isSelected ? 0.15 : 0.05), radius: isSelected ? 6 : 2, x: 0, y: isSelected ? 3 : 1)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview
{
    HStack(spacing: 12)
    {
        QuickFilterChip(
            title: "Beginner",
            icon: "person.fill",
            isSelected: true,
            action: {}
        )

        QuickFilterChip(
            title: "Freestyle",
            icon: "figure.pool.swim",
            isSelected: false,
            action: {}
        )
    }
    .padding()
}
