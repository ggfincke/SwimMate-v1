// LoadingView.swift

import SwiftUI

// loading view
struct LoadingView: View

{

    var body: some View
    {
        VStack(spacing: 16)
        {
            // loading icon
            Image(systemName: "figure.pool.swim")
            .font(.system(size: 40))
            .foregroundColor(.blue)

            Text("Saving Workout")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.primary)

            Text("Processing your swim data...")
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
