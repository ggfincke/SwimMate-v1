// GoalSetupView.swift

import SwiftUI

// modular view for setting up a numeric Goal (distance / calorie)
struct GoalSetupView: View
{
    @Environment(WatchManager.self) private var manager
    
    // properties for config
    var title: String
    var unit: String
    var accentColor: Color
    var presetValues: [Int]
    var minValue: Double
    var maxValue: Double
    
    // binding to update the value
    @Binding var value: Double
    
    // dismiss action
    var onDismiss: () -> Void
    
    // State for showing number pad
    @State private var showingNumberPad = false
    
    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 16)
            {
                // title
                Text(title)
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
                            Text("\(Int(value))")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(accentColor)
                                .monospacedDigit()
                            
                            if !unit.isEmpty
                            {
                                Text(unit)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
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
                        .fill(accentColor.opacity(0.1))
                        .stroke(accentColor.opacity(0.3), lineWidth: 1)
                )
                
                // preset buttons
                if !presetValues.isEmpty
                {
                    VStack(spacing: 12)
                    {
                        Text("Quick Select")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        // preset buttons in rows
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8)
                        {
                            ForEach(presetValues, id: \.self)
                            { presetValue in
                                PresetButton(
                                    value: $value,
                                    presetValue: presetValue,
                                    accentColor: accentColor
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                
                Spacer()
                
                // set button using ActionButton
                ActionButton(
                    label: "Set Goal",
                    icon: "target",
                    tint: accentColor,
                    compact: manager.isCompactDevice
                ) {
                    WKInterfaceDevice.current().play(.success)
                    onDismiss()
                }
                .disabled(value <= 0)
                .opacity(value <= 0 ? 0.6 : 1.0)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 8)
        }
        .sheet(isPresented: $showingNumberPad)
        {
            NumberPadView(
                value: $value,
                title: title,
                unit: unit,
                maxValue: maxValue,
                accentColor: accentColor,
                isCompact: manager.isCompactDevice
            )
        }
    }
    

}

// preview
#Preview
{
    GoalSetupView(
        title: "Distance Goal",
        unit: "meters",
        accentColor: .blue,
        presetValues: [100, 200, 500, 1000, 1500, 2000],
        minValue: 0,
        maxValue: 1000000,
        value: .constant(500.0),
        onDismiss: {}
    )
    .environment(WatchManager())
}
