// DistanceSetupView.swift

import SwiftUI

struct DistanceSetupView: View
{
    @Environment(WatchManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    
    // quick selects for distance
    private let distancePresets = [100, 250, 500, 1000, 2500, 5000]
    
    // state for showin g number pad
    @State private var showingNumberPad = false
    
    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 16)
            {
                // title
                Text("Distance Goal")
                    .font(.headline)
                    .padding(.top, 10)
                
                // current value display (tappable to open number pad)
                Button(action: {
                    showingNumberPad = true
                }) {
                    VStack(spacing: 4)
                    {
                        HStack(alignment: .lastTextBaseline, spacing: 4)
                        {
                            Text("\(Int(manager.goalDistance))")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                                .monospacedDigit()
                            
                            Text(manager.goalUnit == "meters" ? "m" : "yd")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // instruction text
                        Text("Tap to enter value")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
                
                // preset buttons
                VStack(spacing: 12)
                {
                    Text("Quick Select")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    // preset buttons in rows
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8)
                    {
                        ForEach(distancePresets, id: \.self)
                        { presetValue in
                            PresetButton(
                                value: Binding(
                                    get: { manager.goalDistance },
                                    set: { manager.goalDistance = $0 }
                                ),
                                presetValue: presetValue,
                                accentColor: .blue
                            )
                        }
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                // unit selector button
                ActionButton(
                    label: "Unit: \(manager.goalUnit == "meters" ? "Meters" : "Yards")",
                    icon: "arrow.2.circlepath",
                    tint: .orange,
                    compact: manager.isCompactDevice
                ) {
                    WKInterfaceDevice.current().play(.click)
                    manager.goalUnit = manager.goalUnit == "meters" ? "yards" : "meters"
                }
                
                // set goal button using ActionButton
                ActionButton(
                    label: "Set Goal",
                    icon: "target",
                    tint: .blue,
                    compact: manager.isCompactDevice
                ) {
                    WKInterfaceDevice.current().play(.success)
                    // lock the goal unit once set
                    manager.goalUnitLocked = true
                    
                    // return to goal swim setup view
                    dismiss()
                }
                .disabled(manager.goalDistance <= 0)
                .opacity(manager.goalDistance <= 0 ? 0.6 : 1.0)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 8)
        }
        .sheet(isPresented: $showingNumberPad)
        {
            NumberPadView(
                value: Binding(
                    get: { manager.goalDistance },
                    set: { manager.goalDistance = $0 }
                ),
                title: "Distance Goal",
                unit: manager.goalUnit == "meters" ? "m" : "yd",
                maxValue: 5000,
                accentColor: .blue,
                isCompact: manager.isCompactDevice
            )
        }
    }
}

#Preview {
    DistanceSetupView()
        .environment(WatchManager())
}
