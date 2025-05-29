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
    
    // optional unit switching
    var availableUnits: [String]?
    @Binding var selectedUnit: String
    var onUnitChange: ((String) -> Void)?
    
    // dismiss action
    var onDismiss: () -> Void
    
    // State for showing number pad
    @State private var showingNumberPad = false
    
    // computed property for unit display
    private var displayUnit: String {
        if let availableUnits = availableUnits, availableUnits.count > 1 {
            return selectedUnit == "meters" ? "m" : selectedUnit == "yards" ? "yd" : selectedUnit
        }
        return unit
    }
    
    // main initializer with default values for optional parameters
    init(
        title: String,
        unit: String,
        accentColor: Color,
        presetValues: [Int],
        minValue: Double,
        maxValue: Double,
        value: Binding<Double>,
        availableUnits: [String]? = nil,
        selectedUnit: Binding<String> = .constant(""),
        onUnitChange: ((String) -> Void)? = nil,
        onDismiss: @escaping () -> Void
    ) {
        self.title = title
        self.unit = unit
        self.accentColor = accentColor
        self.presetValues = presetValues
        self.minValue = minValue
        self.maxValue = maxValue
        self._value = value
        self.availableUnits = availableUnits
        self._selectedUnit = selectedUnit
        self.onUnitChange = onUnitChange
        self.onDismiss = onDismiss
    }
    
    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 8)
            {
                // title
                Text(title)
                    .font(.headline)
                
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
                            
                            if !displayUnit.isEmpty
                            {
                                Text(displayUnit)
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
                    VStack(spacing: 8)
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
                
                // unit selector button (if available units provided)
                if let availableUnits = availableUnits, availableUnits.count > 1 {
                    ActionButton(
                        label: "\(selectedUnit == "meters" ? "Meters" : selectedUnit == "yards" ? "Yards" : selectedUnit.capitalized)",
                        icon: "arrow.2.circlepath",
                        tint: .teal,
                        compact: manager.isCompactDevice
                    ) {
                        WKInterfaceDevice.current().play(.click)
                        let currentIndex = availableUnits.firstIndex(of: selectedUnit) ?? 0
                        let nextIndex = (currentIndex + 1) % availableUnits.count
                        selectedUnit = availableUnits[nextIndex]
                        onUnitChange?(selectedUnit)
                    }
                }
                
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
                unit: displayUnit,
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
