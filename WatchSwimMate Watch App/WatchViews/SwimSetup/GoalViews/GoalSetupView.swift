// GoalSetupView.swift

import SwiftUI

// modular view for setting up a numeric Goal (distance / calorie)
struct GoalSetupView: View
{
    // properties for config
    var title: String
    var unit: String
    var accentColor: Color
    var presetValues: [Int]
    var minValue: Double
    var maxValue: Double
    var stepValue: Double
    var sensitivity: DigitalCrownRotationalSensitivity
    
    // binding to update the value
    @Binding var value: Double
    
    // dismiss action
    var onDismiss: () -> Void
    
    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 8)
            {
                // title
                Text(title)
                    .font(.headline)
                    .padding(.top, 10)
                
                // current value display
                Text("\(Int(value))")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(accentColor)
                
                // unit
                Text(unit)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // digital crown control
                Text("Use Digital Crown to Adjust")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)

                // visual indicator for digital crown
                HStack
                {
                    Text("-")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Capsule()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 3)
                        .frame(maxWidth: .infinity)
                    
                    Text("+")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .padding(.horizontal)
                .opacity(0.7)
                
                // digital crown integration
                Color.clear
                    .frame(height: 1)
                    .digitalCrownRotation(
                        $value,
                        from: minValue,
                        through: maxValue,
                        by: stepValue,
                        sensitivity: sensitivity,
                        isContinuous: false,
                    )
            
                Spacer()
                
                // set button
                Button
                {
                    WKInterfaceDevice.current().play(.success)
                    onDismiss()
                }
                label:
                {
                    Text("Set Goal")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(accentColor)
                        .cornerRadius(14)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(value <= 0)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 16)
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
        presetValues: [100, 200, 500, 1000, 1500],
        minValue: 0,
        maxValue: 5000,
        stepValue: 25,
        sensitivity: .medium,
        value: .constant(500.0),
        onDismiss: {}
    )
}
