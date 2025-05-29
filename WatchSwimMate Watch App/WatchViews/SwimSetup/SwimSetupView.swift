// SwimSetupView.swift

import SwiftUI

struct SwimSetupView: View
{
    @Environment(WatchManager.self) private var manager
    
    // responsive sizing based on device
    private var headingFontSize: CGFloat
    {
        manager.isCompactDevice ? 16 : 18
    }
    
    private var verticalSpacing: CGFloat
    {
        manager.isCompactDevice ? 12 : 20
    }
    
    private var horizontalPadding: CGFloat
    {
        manager.isCompactDevice ? 12 : 16
    }
    
    private var topPadding: CGFloat
    {
        manager.isCompactDevice ? 4 : 8
    }
    
    var body: some View
    {
        VStack(spacing: verticalSpacing)
        {
            // heading
            Text("Select Type")
                .font(.system(size: headingFontSize, weight: .semibold))
                .padding(.top, topPadding)
            
            // pool swim
            ActionButton(
                label: "Pool",
                icon: "figure.pool.swim",
                tint: .blue,
                compact: manager.isCompactDevice,
                showArrow: true
            ) 
            {
                manager.isPool = true
                manager.path.append(NavState.indoorPoolSetup)
            }
            
            // open water swim
            ActionButton(
                label: "Open Water",
                icon: "water.waves",
                tint: .teal,
                compact: manager.isCompactDevice,
                showArrow: true
            ) 
            {
                manager.isPool = false
                // start workout immediately for open water
                manager.startWorkout()
                manager.path.append(NavState.swimmingView(set: nil))
            }
        }
        .padding(.horizontal, horizontalPadding)
        .navigationTitle("Swim Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview
{
    SwimSetupView()
        .environment(WatchManager())
}
