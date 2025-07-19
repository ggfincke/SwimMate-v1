// SetHeader.swift

import SwiftUI

// SetHeader
struct SetHeader: View

{

    let swimSet: SwimSet
    let currentStep: Int
    let totalSteps: Int

    var body: some View
    {
        VStack(spacing: 6)
        {
            // set title
            Text(swimSet.title)
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)

            // details
            Text("\(swimSet.totalDistance) \(swimSet.measureUnit.rawValue.lowercased()) • \(swimSet.primaryStroke?.description ?? "Mixed")")
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)

            // progress bar
            ProgressBar(current: currentStep-1, total: totalSteps)
        }
    }
}
