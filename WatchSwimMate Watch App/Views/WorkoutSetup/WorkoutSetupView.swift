//
//  WorkoutSetupView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

struct WorkoutSetupView: View, Hashable
{
    @EnvironmentObject var manager: WatchManager
    @State private var navigateToPoolSetup = false
    @State private var showSwimmingView = false
    
    var body: some View
    {
        VStack
        {
            // pool swim
            Button("Pool")
            {
                manager.isPool = true
                navigateToPoolSetup = true
            }
            .padding()
            .foregroundColor(.white)
            .navigationDestination(isPresented: $navigateToPoolSetup)
            {
               IndoorPoolSetupView()
            }
            
            // open water swim
            Button("Open Water")
            {
                manager.isPool = false
                showSwimmingView = true
                // navigate to SwimmingView
                manager.startWorkout()
            }
            .padding()
            .foregroundColor(.white)
            .navigationDestination(isPresented: $showSwimmingView)
            {
                SwimmingView(swimmySet: nil)
            }
        }
    }
}


#Preview
{
    
    WorkoutSetupView()
        .environmentObject(WatchManager())

}
