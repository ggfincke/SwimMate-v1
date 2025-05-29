// SwimmingView.swift

import SwiftUI
import WatchKit

// Main SwimmingView - tab view for WorkoutControls, Metrics, & SetDisplay
struct SwimmingView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var selection: Tab = .metrics
    @State private var isInitialized = false
    
    let set: SwimSet?
    
    // available tabs
    private enum Tab: String, CaseIterable
    {
        case controls = "Controls"
        case metrics = "Metrics"
        case set = "Set"
        case goals = "Goals"
        
        var icon: String
        {
            switch self
            {
            case .controls: return "hand.tap.fill"
            case .metrics: return "chart.line.uptrend.xyaxis"
            case .set: return "list.bullet.clipboard"
            case .goals: return "target"
            }
        }
        
        var color: Color
        {
            switch self
            {
            case .controls: return .orange
            case .metrics: return .blue
            case .set: return .green
            case .goals: return .purple
            }
        }
    }
    
    // set init
    init(set: SwimSet?)
    {
        self.set = set
    }
    
    var body: some View
    {
        ZStack
        {
            // main horizontal tab content
            TabView(selection: $selection)
            {
                // Controls Tab
                SwimControlsView()
                    .tag(Tab.controls)

                // Metrics Tab
                MetricsView()
                    .tag(Tab.metrics)
                
                // Set Tab (if available)
                if let set = set
                {
                    SetDisplayView(swimSet: set)
                        .tag(Tab.set)
                }
                
                // Goals Tab (if goals are set)
                if manager.hasActiveGoals
                {
                    GoalProgressView()
                        .tag(Tab.goals)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .onAppear
            {
                if !isInitialized
                {
                    setupInitialTab()
                    isInitialized = true
                }
            }
        
        }
        .navigationBarBackButtonHidden(true)
        .onAppear
        {
            // ensure water lock is enabled when starting workout
            if manager.running
            {
                WKInterfaceDevice.current().enableWaterLock()
            }
        }
    }
    
    // MARK: - Helper Properties
    
    // available tabs
    private var availableTabs: [Tab]
    {
        var tabs: [Tab] = [.controls, .metrics]
        
        if set != nil
        {
            tabs.append(.set)
        }
        
        if manager.hasActiveGoals
        {
            tabs.append(.goals)
        }
        
        return tabs
    }
    
    // setup initial tab
    private func setupInitialTab()
    {
        // prioritize goals when they exist (user just set them)
        if manager.hasActiveGoals
        {
            selection = .goals
        }
        // if set is available, show set tab (set and goals are mutually exclusive)
        else if let _ = set
        {
            selection = .set
        }
        // default to metrics tab
        else
        {
            selection = .metrics
        }
    }
}

// preview
#Preview
{
    let sampleSet = SwimSet(
        title: "Endurance Set",
        primaryStroke: .freestyle,
        totalDistance: 1500,
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "Build endurance with this progressive set",
        details: [
            "400m warm-up easy",
            "8x100m on 1:30",
            "4x200m on 3:00",
            "200m cool down"
        ]
    )
    
    SwimmingView(set: sampleSet)
        .environmentObject(WatchManager())
}
