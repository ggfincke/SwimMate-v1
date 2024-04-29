//
//  IndoorPoolSetupView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

struct IndoorPoolSetupView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var showUnitPicker = false
    @State private var showSwimmingView = false

    var swimmySet: SwimSet?

    var body: some View
    {
        VStack
        {
            Text("\(Int(manager.poolLength)) \(manager.poolUnit)")
                .padding()
            
            HStack
            {
                Button(action: {
                    if manager.poolLength > 10 { manager.poolLength -= 1 }
                })
                {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
            

                Button(action: {
                    if manager.poolLength < 50 { manager.poolLength += 1 }
                })
                {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
            }

            Button("Select Unit") 
            {
                showUnitPicker = true
            }
            .sheet(isPresented: $showUnitPicker) {
                UnitPickerView(selectedUnit: $manager.poolUnit)
            }

            Button("Start Workout") 
            {
                manager.startWorkout()
                showSwimmingView = true
                // nav or action to start the workout
            }
            .navigationDestination(isPresented: $showSwimmingView) 
            {
                if (swimmySet != nil)
                {
                    SwimmingView(swimmySet: swimmySet)
                }
                else
                {
                    SwimmingView(swimmySet: nil)
                }
            }
        }
        .padding()
    }
}


#Preview
{
    IndoorPoolSetupView()
        .environmentObject(WatchManager())
}
