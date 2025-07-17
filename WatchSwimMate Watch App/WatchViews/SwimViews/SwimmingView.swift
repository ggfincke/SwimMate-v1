// SwimmingView.swift

import SwiftUI
import WatchKit

// Main SwimmingView
struct SwimmingView: View
{
    @Environment(WatchManager.self) private var manager
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
#Preview("Basic Workout - No Goals")
{
    let sampleSet = SwimSet(
        title: "Endurance Set",
        components: [
            SetComponent(type: .warmup, distance: 400, strokeStyle: .mixed, instructions: "400m warm-up easy"),
            SetComponent(type: .swim, distance: 800, strokeStyle: .freestyle, instructions: "8x100m on 1:30"),
            SetComponent(type: .swim, distance: 800, strokeStyle: .freestyle, instructions: "4x200m on 3:00"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200m cool down")
        ],
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "Build endurance with this progressive set"
    )
    
    SwimmingView(set: sampleSet)
        .environment(WatchManager())
}

#Preview("Workout with Distance Goal")
{
    let manager = WatchManager()
    manager.goalDistance = 1000
    manager.distance = 650  // 65% progress
    manager.goalUnit = "meters"
    
    return SwimmingView(set: nil)
        .environment(manager)
}

#Preview("Workout with Multiple Goals")
{
    let manager = WatchManager()
    manager.goalDistance = 1500
    manager.distance = 900  // 60% progress
    manager.goalTime = 1800  // 30 minutes
    manager.elapsedTime = 1200  // 20 minutes (67% progress)
    manager.goalCalories = 400
    manager.activeEnergy = 280  // 70% progress
    manager.goalUnit = "meters"
    
    return SwimmingView(set: nil)
        .environment(manager)
}

#Preview("Goals Nearly Complete")
{
    let manager = WatchManager()
    manager.goalDistance = 1000
    manager.distance = 950  // 95% progress
    manager.goalTime = 1800  // 30 minutes
    manager.elapsedTime = 1650  // 27.5 minutes (92% progress)
    manager.goalCalories = 350
    manager.activeEnergy = 330  // 94% progress
    manager.goalUnit = "meters"
    
    return SwimmingView(set: nil)
        .environment(manager)
}

#Preview("Goals Exceeded")
{
    let manager = WatchManager()
    manager.goalDistance = 800
    manager.distance = 950  // 119% progress
    manager.goalTime = 1500  // 25 minutes
    manager.elapsedTime = 1680  // 28 minutes (112% progress)
    manager.goalCalories = 300
    manager.activeEnergy = 340  // 113% progress
    manager.goalUnit = "meters"
    
    return SwimmingView(set: nil)
        .environment(manager)
}

#Preview("Set + Goals Combination")
{
    let sampleSet = SwimSet(
        title: "Sprint Set",
        components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200m warm-up"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .freestyle, instructions: "8x50m on 1:00 all-out"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .freestyle, instructions: "4x100m on 2:00 fast"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200m cool down")
        ],
        measureUnit: .meters,
        difficulty: .advanced,
        description: "High intensity sprint training"
    )
    
    let manager = WatchManager()
    manager.goalDistance = 800
    manager.distance = 400  // 50% progress
    manager.goalTime = 1200  // 20 minutes
    manager.elapsedTime = 600  // 10 minutes (50% progress)
    manager.goalUnit = "meters"
    
    return SwimmingView(set: sampleSet)
        .environment(manager)
}
