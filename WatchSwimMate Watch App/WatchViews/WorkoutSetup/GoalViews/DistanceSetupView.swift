//
//  DistanceSetupView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

struct DistanceSetupView: View 
{
    @EnvironmentObject var manager: WatchManager
    @State private var showWorkoutView = false


    var body: some View 
    {
        NavigationStack
        {
            VStack(spacing: 10)
            {
                
                Text("\(Int(manager.goalDistance))" + " Laps")
                    .padding()
                
                // w/ digital crown integration to adjust distance
                HStack
                {
                    Button(action: {
                        if manager.goalDistance > 0
                        {
                            manager.goalDistance -= 1
                        }
                    })
                    {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        manager.goalDistance += 1
                    })
                    {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .digitalCrownRotation($manager.goalDistance, from: 0, through: 1000, by: 1, sensitivity: .low, isContinuous: false)
                
                Button("Continue")
                {
                    showWorkoutView = true
                }
                .padding()
                .foregroundColor(.white)
                .navigationDestination(isPresented: $showWorkoutView) {
                    WorkoutSetupView()
                }
            }
            .padding()
        }
    }
}

#Preview 
{
    DistanceSetupView()
        .environmentObject(WatchManager())
}
