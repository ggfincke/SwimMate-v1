// CompactNavButton.swift

import SwiftUI

// Nav buttons
struct CompactNavButton: View

{

    let icon: String
    let isEnabled: Bool
    let color: Color
    let action: () -> Void

    @State private var isPressed = false

    var body: some View
    {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1))
            {
                isPressed = true
            }

            action()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
            {
                withAnimation {
                    isPressed = false
                }
            }
            })
            {
                Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isEnabled ? .white : .secondary)
                .frame(width: 40, height: 40)
                .background(
                Circle()
                .fill(isEnabled ? color : Color.gray.opacity(0.3))
                .scaleEffect(isPressed ? 0.9 : 1.0)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!isEnabled)
        }
    }

    // preview
    #Preview {
        HStack(spacing: 16)
        {
            CompactNavButton(
            icon: "chevron.left",
            isEnabled: true,
            color: .blue
            )
            {
                print("Back tapped")
            }

            CompactNavButton(
            icon: "play.fill",
            isEnabled: true,
            color: .green
            )
            {
                print("Play tapped")
            }

            CompactNavButton(
            icon: "chevron.right",
            isEnabled: false,
            color: .gray
            )
            {
                print("Forward tapped")
            }
        }
        .padding()
    }
