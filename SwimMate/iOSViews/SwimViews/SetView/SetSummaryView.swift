// SwimMate/iOSViews/SwimViews/SetView/SetSummaryView.swift

import SwiftUI

struct SetSummaryView: View
{
    let swimmySet: SwimSet
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text(swimmySet.title).font(.headline)
            Text("\(swimmySet.totalDistance) \(swimmySet.measureUnit.rawValue) - \(swimmySet.strokeDisplayLabel)")
            Text(swimmySet.description ?? "").font(.subheadline)
        }
    }
}

#Preview
{
    SetSummaryView(swimmySet: SwimSet(
        id: UUID(),
        title: "Sprint Training",
        components: [],
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "High intensity sprint workout"
    ))
}
