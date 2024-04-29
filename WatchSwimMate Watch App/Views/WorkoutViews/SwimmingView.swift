//
//  SwimmingView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI
import WatchKit

struct SwimmingView: View
{
    @EnvironmentObject var manager: WatchManager
    enum Tab
    {
        case controls, metrics, set
    }
    var swimmySet: SwimSet?
    @State private var selection: Tab

    // init to see if set exists
    init(swimmySet: SwimSet?)
    {
        self.swimmySet = swimmySet
        _selection = State(initialValue: swimmySet != nil ? .set : .metrics)
    }


    var body: some View
    {
        
        TabView(selection: $selection)
        {
            WorkoutControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            if let swimmySet = swimmySet
            {
                SetDisplayView(swimSet: swimmySet).tag(Tab.set)
            }
        }
    }
}

struct SwimmingView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let sampleSet = SwimSet(
            title: "Sample",
            primaryStroke: .freestyle,
            totalDistance: 2000,
            measureUnit: .meters,
            difficulty: .intermediate,
            description: "A challenging set designed to improve endurance and pace.",
            details: ["800 warmup mix", "10x100 on 1:30, descend 1-5, 6-10", "10x50 kick on 1:00", "500 cool down easy"]
        )
        SwimmingView(swimmySet: sampleSet)
            .environmentObject(WatchManager())
    }
}

