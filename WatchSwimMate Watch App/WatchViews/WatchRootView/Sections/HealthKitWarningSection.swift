// HealthKitWarningSection.swift

import SwiftUI

// health kit warning
struct HealthKitWarningSection: View

{

    @Binding var showSettings: Bool

    var body: some View
    {
        HStack(spacing: 8)
        {
            Image(systemName: "exclamationmark.triangle.fill")
            .foregroundColor(.orange)
            .font(.system(size: 14))

            VStack(alignment: .leading, spacing: 2)
            {
                Text("HealthKit Access Required")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)

                Text("Enable in Settings to track workouts")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            }

            Spacer()

            Button("Fix")
            {
                showSettings = true
            }
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
        RoundedRectangle(cornerRadius: 8)
        .fill(Color.orange.opacity(0.1))
        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 12)
    }
}

#Preview {
    HealthKitWarningSection(showSettings: .constant(false))
}
