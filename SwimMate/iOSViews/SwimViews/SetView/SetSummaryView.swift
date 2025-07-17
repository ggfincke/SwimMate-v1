// SwimMate/iOSViews/SwimViews/SetView/SetSummaryView.swift

import SwiftUI

struct SetSummaryView: View
{
    let swimmySet : SwimSet
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text(swimmySet.title).font(.headline)
            Text("\(swimmySet.totalDistance) \(swimmySet.measureUnit.rawValue) - \(swimmySet.primaryStroke?.description ?? "Mixed")")
            Text(swimmySet.description ?? "").font(.subheadline)
        }
    }
}


