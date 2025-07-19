// SwimMate/iOSViews/Components/Display/EmptyStateView.swift

import SwiftUI

struct EmptyStateView: View
{
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View
    {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    EmptyStateView(
        icon: "figure.pool.swim",
        title: "No recent swims",
        subtitle: "Start your first workout to see your activity here"
    )
}