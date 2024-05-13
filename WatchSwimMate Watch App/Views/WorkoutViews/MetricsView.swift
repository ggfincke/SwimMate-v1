//
//  MetricsView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/28/24.
//

import SwiftUI

//TODO: adjust to look better
struct MetricsView: View
{
    @EnvironmentObject var manager: WatchManager
    var body: some View
    {
        TimelineView(MetricsTimelineSchedule(from: manager.workoutBuilder?.startDate ?? Date())) 
        { context in
            VStack(alignment: .leading)
            {
                ElapsedTimeView(elapsedTime: manager.workoutBuilder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live)
                    .foregroundStyle(.yellow)
                Text(Measurement(value: manager.activeEnergy, unit: UnitEnergy.kilocalories)
                        .formatted(.measurement(width: .abbreviated, usage: .workout)))
                Text(manager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                Text("\(Int(manager.distance.rounded())) \(manager.poolUnit == "meters" ? "m" : "yd")")

            }
            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
    }
}


private struct MetricsTimelineSchedule: TimelineSchedule
{
    var startDate: Date

    init(from startDate: Date) 
    {
        self.startDate = startDate
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries
    {
        PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
    }
}

#Preview
{
    MetricsView()
        .environmentObject(WatchManager())
}
