// MetricsView.swift

import SwiftUI

// MetricsView
struct MetricsView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var isVisible = false
    
    // spacing vars
    private let sectionSpacing: CGFloat = 6
    private let horizontalPadding: CGFloat = 4
    
    var body: some View
    {
        TimelineView(
            MetricsTimelineSchedule(from: manager.workoutBuilder?.startDate ?? .now)
        )
        { context in
            
            VStack(spacing: sectionSpacing)
            {
                PrimaryMetricsSection(showSubseconds: context.cadence == .live)
                SecondaryMetricsGrid()
                // will use eventually, user-selectable metrics?
                // PerformanceMetricsSection()
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, 10)
            .padding(.bottom, 4)
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear { withAnimation { isVisible = true } }
    }
}

// Timeline Schedule
private struct MetricsTimelineSchedule: TimelineSchedule
{
    var startDate: Date
    
    init(from startDate: Date)
    {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries
    {
        PeriodicTimelineSchedule(
            from: self.startDate,
            by: mode == .lowFrequency ? 1.0 : 1.0 / 30.0
        ).entries(from: startDate, mode: mode)
    }
}

// preview
#Preview {
    MetricsView()
        .environmentObject(WatchManager())
}
