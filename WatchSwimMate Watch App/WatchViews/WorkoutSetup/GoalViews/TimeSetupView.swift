//
//  TimeSetupView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

struct TimeSetupView: View 
{
    @EnvironmentObject var manager: WatchManager
    @State private var showWorkoutView = false

    
    var hours: [Int] = Array(0...23)
    var minutes: [Int] = Array(0...59)
    var body: some View
    {
        NavigationStack
        {
            VStack(spacing: 0)
            {
                Text("Set Time Goal")
                    .font(.headline)
                    .padding()
                
                // Custom picker for hours
                HStack {
                    Picker(selection: $manager.goalHours, label: Text("Hours"))
                    {
                        ForEach(hours, id: \.self) { hour in
                            Text(String(format: "%02d", hour)).tag(hour)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 50, height: 50)
                    .clipped()
                    
                    Text(":")
                        .foregroundColor(.green)
                    
                    Picker(selection: $manager.goalMinutes, label: Text("Minutes"))
                    {
                        ForEach(minutes, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 50, height: 50)
                    .clipped()
                }
                .padding()
                
                Button("Continue")
                {
                    showWorkoutView = true
                }
                .padding()
                .foregroundColor(.white)
                .navigationDestination(isPresented: $showWorkoutView)
                {
                    WorkoutSetupView()
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    TimeSetupView()
        .environmentObject(WatchManager())
}
