// TimeSetupView.swift

import SwiftUI

struct TimeSetupView: View
{
    @Environment(WatchManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    
    // state for time pickers
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    // quick set time values (minutes)
    private let timePresets = [15, 30, 45, 60, 90]
    
    var body: some View
    {
        ScrollView
        {
            VStack(spacing: GoalSpacingConstants.mainContainer)
            {
                // title
                Text("Time Goal")
                    .font(.headline)
                    .padding(.top, GoalSpacingConstants.topSection)
                
                // current time display
                Text(timeString)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.purple)
                    .monospacedDigit()
                
                GeometryReader
                { geometry in
                    HStack(spacing: 0)
                    {
                        // hours
                        Picker("Hours", selection: $hours)
                        {
                            ForEach(0...WatchManager.maxTimeGoalHours, id: \.self)
                            { hour in
                                Text("\(hour) hr").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: geometry.size.width/2)
                        .clipped()
                        .onChange(of: hours)
                        { _, _ in
                            updateGoalTime()
                        }
                        
                        // minutes
                        Picker("Minutes", selection: $minutes)
                        {
                            ForEach(0..<60, id: \.self)
                            { minute in
                                if minute % 5 == 0 
                                {
                                    Text("\(minute) min").tag(minute)
                                }
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: geometry.size.width/2)
                        .clipped()
                        .onChange(of: minutes) 
                        { _, _ in
                            updateGoalTime()
                        }
                    }
                }
                .frame(height: 100)
                .padding(.horizontal, -GoalSpacingConstants.horizontalMain)
                
                // presets
                VStack(spacing: GoalSpacingConstants.standardContent)
                {
                    Text("Quick Set")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    // preset buttons
                    HStack(spacing: GoalSpacingConstants.presetButtons)
                    {
                        ForEach(timePresets.prefix(3), id: \.self)
                        { minutes in
                            presetButton(minutes: minutes)
                        }
                    }
                    
                    HStack(spacing: GoalSpacingConstants.presetButtons)
                    {
                        ForEach(timePresets.suffix(2), id: \.self)
                        { minutes in
                            presetButton(minutes: minutes)
                        }
                    }
                }
                .padding(.top, GoalSpacingConstants.topSection)
                
                Spacer()
                
                // set button using ActionButton
                ActionButton(
                    label: "Set Goal",
                    icon: "clock.fill",
                    tint: .purple,
                    compact: manager.isCompactDevice
                ) 
                {
                    WKInterfaceDevice.current().play(.success)
                    dismiss()
                }
                .disabled(hours == 0 && minutes == 0)
                .opacity(hours == 0 && minutes == 0 ? 0.6 : 1.0)
                .padding(.bottom, GoalSpacingConstants.bottomAction)
            }
            .padding(.horizontal, GoalSpacingConstants.horizontalMain)
            .padding(.bottom, GoalSpacingConstants.bottomLarge)
        }
        .onAppear
        {
            // init w/ current values
            if manager.goalTime > 0
            {
                hours = Int(manager.goalTime) / 3600
                minutes = (Int(manager.goalTime) % 3600) / 60
            }
        }
    }
    
    // format time string
    var timeString: String
    {
        let formattedHours = String(format: "%02d", hours)
        let formattedMinutes = String(format: "%02d", minutes)
        return "\(formattedHours):\(formattedMinutes)"
    }
    
    // update goal time based on hours & minutes
    private func updateGoalTime()
    {
        manager.goalTime = TimeInterval(hours * 3600 + minutes * 60)
    }
    
    // preset button for quick time selection
    private func presetButton(minutes: Int) -> some View
    {
        let hrs = minutes / 60
        let mins = minutes % 60
        let isSelected = hours == hrs && self.minutes == mins
        
        return Button
        {
            WKInterfaceDevice.current().play(.click)
            hours = hrs
            self.minutes = mins
            updateGoalTime()
        }
        label:
        {
            Text("\(minutes)m")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isSelected ? Color.purple : Color.secondary.opacity(0.2))
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview
{
    TimeSetupView()
        .environment(WatchManager())
}
