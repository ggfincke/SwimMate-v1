// PresetButton.swift

import SwiftUI

// preset button
struct PresetButton: View {
    @Binding var value: Double
    let presetValue: Int
    let accentColor: Color
    
    var body: some View {
        let isSelected = Int(value) == presetValue
        
        Button {
            WKInterfaceDevice.current().play(.click)
            value = Double(presetValue)
        } label: {
            Text("\(presetValue)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    isSelected ? accentColor : Color.secondary.opacity(0.15)
                )
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// preview
#Preview {
    VStack(spacing: 12) {
        PresetButton(
            value: .constant(100.0),
            presetValue: 100,
            accentColor: .blue
        )
        
        PresetButton(
            value: .constant(200.0),
            presetValue: 100,
            accentColor: .blue
        )
    }
    .padding()
}