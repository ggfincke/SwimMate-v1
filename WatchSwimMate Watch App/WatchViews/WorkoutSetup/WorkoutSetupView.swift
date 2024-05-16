//
//  WorkoutSetupView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

struct WorkoutSetupView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var navigateToPoolSetup = false
    
    var body: some View
    {
        VStack
        {
            // pool swim
            Button("Pool")
            {
                manager.isPool = true
                manager.path.append(NavState.indoorPoolSetup)
            }
            .padding()
            .foregroundColor(.white)

            
            // open water swim
            Button("Open Water")
            {
                manager.isPool = false
                manager.path.append(NavState.swimmingView(set: nil))
                manager.startWorkout()
            }
            .padding()
            .foregroundColor(.white)

        }
    }
}


#Preview
{
    
    WorkoutSetupView()
        .environmentObject(WatchManager())

}
