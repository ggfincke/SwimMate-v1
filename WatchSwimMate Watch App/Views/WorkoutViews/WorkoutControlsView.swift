//
//  WorkoutControlsView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

// displays controls for the workout
struct WorkoutControlsView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var showSummary = false
    @State private var backToMain = false

    var body: some View
    {
        VStack(spacing: 15)
        {
            HStack(spacing: 15)
            {
                // pause/continue workout
                Button(action: {manager.togglePause()})
                {
                    VStack
                    {
                        Image(systemName: manager.running ? "pause" : "play")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 60, height: 60)
                    .foregroundColor(.black)
                    .background(Circle().fill(Color.yellow))
                    .padding()
                }
                
                // end workout
                Button(action: {
                    manager.endWorkout()
                    showSummary = true
                })
                {
                    VStack
                    {
                        Image(systemName: "stop.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.red))
                    .foregroundColor(.white)
                    .padding()

                }
                .navigationDestination(isPresented: $backToMain) {
                    WatchRootView()
                }
            }

            // enable water lock
            HStack(spacing: 15)
            {
                Button(action: {
                    WKInterfaceDevice.current().enableWaterLock()
                })
                {
                VStack
                    {
                        Image(systemName: "drop")
                            .resizable()
                            .frame(width: 20, height: 25)
                    }
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.blue))
                    .foregroundColor(.white)
                    .padding()

                }

                // segment 
                Button(action: {
                    // Placeholder for adding a segment
                })
                {
                    VStack
                    {
                        Image(systemName: "flag.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.green))
                    .foregroundColor(.white)
                    .padding()
                }
            }
        }
        .padding()
        .sheet(isPresented: $showSummary) {
            SwimmingSummaryView()
                .environmentObject(manager)
        }
    }
}

#Preview 
{
    WorkoutControlsView()
        .environmentObject(WatchManager())
}
