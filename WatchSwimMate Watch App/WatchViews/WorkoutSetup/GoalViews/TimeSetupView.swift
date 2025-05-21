// TimeSetupView

import SwiftUI

struct TimeSetupView: View {
    @EnvironmentObject var manager: WatchManager
    @Environment(\.dismiss) private var dismiss
    
    // state for time pickers
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    // quick set time values (minutes)
    private let timePresets = [15, 30, 45, 60, 90]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // title
                Text("Time Goal")
                    .font(.headline)
                    .padding(.top, 8)
                
                // current time display
                Text(timeString)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
                    .monospacedDigit()
                
                // TODO: FIX - Picker section (works wrong with ScrollView)
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        // hours
                        Picker("Hours", selection: $hours) {
                            ForEach(0...6, id: \.self) { hour in
                                Text("\(hour) hr").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: geometry.size.width/2)
                        .clipped()
                        .onChange(of: hours) { _, _ in
                            updateGoalTime()
                        }
                        
                        // minutes
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60, id: \.self) { minute in
                                if minute % 5 == 0 {
                                    Text("\(minute) min").tag(minute)
                                }
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: geometry.size.width/2)
                        .clipped()
                        .onChange(of: minutes) { _, _ in
                            updateGoalTime()
                        }
                    }
                }
                .frame(height: 100)
                .padding(.horizontal, -8)
                
                // presets
                VStack(spacing: 8) {
                    Text("Quick Set")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    // preset buttons
                    HStack(spacing: 8) {
                        ForEach(timePresets.prefix(3), id: \.self) { minutes in
                            presetButton(minutes: minutes)
                        }
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(timePresets.suffix(2), id: \.self) { minutes in
                            presetButton(minutes: minutes)
                        }
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                // set button
                Button {
                    WKInterfaceDevice.current().play(.success)
                    dismiss()
                } label: {
                    Text("Set Goal")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red)
                        .cornerRadius(14)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(hours == 0 && minutes == 0)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .onAppear {
            // init w/ current values
            if manager.goalTime > 0 {
                hours = Int(manager.goalTime) / 3600
                minutes = (Int(manager.goalTime) % 3600) / 60
            }
        }
    }
    
    // format time string
    var timeString: String {
        let formattedHours = String(format: "%02d", hours)
        let formattedMinutes = String(format: "%02d", minutes)
        return "\(formattedHours):\(formattedMinutes)"
    }
    
    // update goal time based on hours & minutes
    private func updateGoalTime() {
        manager.goalTime = TimeInterval(hours * 3600 + minutes * 60)
    }
    
    // preset button for quick time selection
    private func presetButton(minutes: Int) -> some View {
        let hrs = minutes / 60
        let mins = minutes % 60
        let isSelected = hours == hrs && self.minutes == mins
        
        return Button {
            WKInterfaceDevice.current().play(.click)
            hours = hrs
            self.minutes = mins
            updateGoalTime()
        } label: {
            Text("\(minutes)m")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isSelected ? Color.red : Color.secondary.opacity(0.2))
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TimeSetupView()
        .environmentObject(WatchManager())
}
