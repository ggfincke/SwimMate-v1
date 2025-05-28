// MainButton.swift

import SwiftUI

struct MainButton: View {
    let label: String
    let icon: String
    let tint: Color
    let buttonId: String
    let isEnabled: Bool
    let compact: Bool
    @Binding var activeButton: String?
    let action: () -> Void
    
    init(
        label: String,
        icon: String,
        tint: Color,
        buttonId: String,
        isEnabled: Bool = true,
        compact: Bool = false,
        activeButton: Binding<String?>,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.tint = tint
        self.buttonId = buttonId
        self.isEnabled = isEnabled
        self.compact = compact
        self._activeButton = activeButton
        self.action = action
    }
    
    var body: some View {
        Button(action: action)
        {
            HStack(spacing: compact ? 6 : 10)
            {
                Image(systemName: icon)
                    .font(.system(size: compact ? 14 : 16))
                Text(label)
                    .font(.system(size: compact ? 14 : 16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: compact ? 10 : 12))
                    .opacity(0.7)
            }
            .foregroundColor(isEnabled ? .white : .secondary)
            .padding(.horizontal, compact ? 8 : 12)
            .padding(.vertical, compact ? 8 : 12)
            .background(
                activeButton == buttonId ? tint.opacity(0.8) : tint
            )
            .cornerRadius(compact ? 10 : 12)
            .scaleEffect(activeButton == buttonId ? 0.95 : 1)
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}

// preview
#Preview
{
    VStack(spacing: 10)
    {
        // normal main button
        MainButton(
            label: "Quick Start",
            icon: "bolt.fill",
            tint: .green,
            buttonId: "quick",
            isEnabled: true,
            activeButton: .constant(nil)
        )
        {
            
        }
        
        // compact main button
        MainButton(
            label: "Compact Mode",
            icon: "heart.fill",
            tint: .pink,
            buttonId: "compact",
            isEnabled: true,
            compact: true,
            activeButton: .constant(nil)
        )
        {
            
        }
    }
    .padding()
}
