//
//  GoalWorkoutSetupView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

struct GoalWorkoutSetupView: View 
{
    @EnvironmentObject var manager: WatchManager
    @State private var navigateToRegSetup = false
    @State private var navigateToDistanceSetup = false
    @State private var navigateToTimeSetup = false
    @State private var navigateToCalorieSetup = false

    var body: some View 
    {
        NavigationStack
        {
            ScrollView
            {
                VStack(spacing: 15)
                {
                    Button("Open") {
                        navigateToRegSetup = true
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.top)
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $navigateToRegSetup)
                    {
                        WorkoutSetupView()
                    }

                    Button("Distance") {
                        navigateToDistanceSetup = true
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $navigateToDistanceSetup)
                    {
                        DistanceSetupView().environmentObject(manager)
                    }

                    Button("Time") {
                        navigateToTimeSetup = true
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $navigateToTimeSetup)
                    {
                        TimeSetupView().environmentObject(manager)
                    }

//                    Button("Calorie") {
//                        navigateToCalorieSetup = true
//                    }
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.orange)
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//                    .navigationDestination(isPresented: $navigateToCalorieSetup)
//                    {
//                        CalorieSetupView().environmentObject(manager)
//                    }
                }
                .padding()
            }
        }
    }
}

#Preview 
{
    GoalWorkoutSetupView()
        .environmentObject(WatchManager())
}
