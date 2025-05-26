// SwimmingSummaryView.swift

import SwiftUI
import HealthKit
import WatchKit

// post-workout summary view
struct SwimmingSummaryView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var isVisible = false
    @State private var showCelebration = false
    
    // store initial values (need bc we reset manager during view display)
    @State private var initialDistance: Double = 0
    @State private var initialActiveEnergy: Double = 0
    @State private var initialAverageHeartRate: Double = 0
    @State private var initialWorkout: HKWorkout?
    @State private var initialLaps: Int = 0
    
    private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View
    {
        GeometryReader
        { geometry in
            ZStack
            {
                // if any workout data
                if hasWorkoutData
                {
                    // summary content
                    ScrollView
                    {
                        VStack(spacing: 20)
                        {
                            // header w/ celebration
                            SummaryHeaderView()
                                .opacity(isVisible ? 1 : 0)
                                .scaleEffect(isVisible ? 1 : 0.8)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: isVisible)
                            
                            // key metrics cards
                            KeyMetricsSection()
                                .opacity(isVisible ? 1 : 0)
                                .offset(y: isVisible ? 0 : 30)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isVisible)
                            
                            // performance insights
                            PerformanceInsightsSection()
                                .opacity(isVisible ? 1 : 0)
                                .offset(y: isVisible ? 0 : 30)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: isVisible)
                            
                            // footer
                            SummaryFooter()
                                .opacity(isVisible ? 1 : 0)
                                .offset(y: isVisible ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: isVisible)
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 8)
                        .safeAreaInset(edge: .bottom)
                        {
                            Color.clear.frame(height: 0)
                        }
                    }
                    .ignoresSafeArea(.container, edges: .top)
                }
                else
                {
                    // loadingview
                    LoadingView()
                }
                
                // celebration overlay
                if showCelebration
                {
                    CelebrationOverlay()
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .onAppear
        {
            setupSummaryView()
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // if workout data from either current manager state or stored initial values
    private var hasWorkoutData: Bool {
        return initialDistance > 0 || manager.distance > 0 || initialWorkout != nil || manager.workout != nil
    }
    
    // setup summary view
    private func setupSummaryView()
    {
        // store initial values 
        initialDistance = manager.distance
        initialActiveEnergy = manager.activeEnergy
        initialAverageHeartRate = manager.averageHeartRate
        initialWorkout = manager.workout
        initialLaps = manager.laps
        
        // trigger haptic feedback
        WKInterfaceDevice.current().play(.success)
        
        // show celebration for exceptional workouts
        if shouldShowCelebration()
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6))
                {
                    showCelebration = true
                }
                
                // auto-hide celebration
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5)
                {
                    withAnimation(.easeOut(duration: 0.5))
                    {
                        showCelebration = false
                    }
                }
            }
        }
        
        // animate content in
        withAnimation {
            isVisible = true
        }
    }
    
    private func shouldShowCelebration() -> Bool
    {
        // use stored initial values or current manager values
        let duration = manager.workout?.duration ?? initialWorkout?.duration ?? 0
        let distance = manager.workout?.totalDistance?.doubleValue(for: .meter()) ?? initialDistance
        
        return duration > 1800 || distance > 1000
    }
}

// preview
#Preview {
    SwimmingSummaryView()
        .environmentObject({
            let manager = WatchManager()
            // simulate completed workout
            manager.distance = 1500
            manager.averageHeartRate = 145
            manager.laps = 30
            return manager
        }())
}
