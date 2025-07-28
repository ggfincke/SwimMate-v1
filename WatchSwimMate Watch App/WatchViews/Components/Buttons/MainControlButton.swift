// MainControlButton.swift

import SwiftUI

// large main control button for 2x2 grid
struct MainControlButton: View
{
    let icon: String
    let label: String
    let color: Color
    let isCompact: Bool
    let action: () -> Void

    @State private var isAnimating = false

    // responsive sizing properties
    private var circleSize: CGFloat
    {
        isCompact ? 55 : 70
    }

    private var iconSize: CGFloat
    {
        isCompact ? 22 : 28
    }

    private var labelSize: CGFloat
    {
        isCompact ? 10 : 12
    }

    private var verticalSpacing: CGFloat
    {
        isCompact ? 4 : 6
    }

    private var shadowRadius: CGFloat
    {
        isCompact ? 3 : 4
    }

    var body: some View
    {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.8))
            {
                isAnimating = true
            }

            action()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
            {
                withAnimation
                {
                    isAnimating = false
                }
            }
        })
        {
            VStack(spacing: verticalSpacing)
            {
                ZStack
                {
                    Circle()
                        .fill(color)
                        .frame(width: circleSize, height: circleSize)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: isCompact ? 0.5 : 1)
                        )
                        .shadow(
                            color: color.opacity(0.3),
                            radius: isAnimating ? shadowRadius + 2 : shadowRadius,
                            x: 0,
                            y: isCompact ? 1 : 2
                        )

                    Image(systemName: icon)
                        .font(.system(size: iconSize, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(isAnimating ? 0.95 : 1.0)

                Text(label)
                    .font(.system(size: labelSize, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// preview
#Preview
{
    ScrollView
    {
        VStack(spacing: 20)
        {
            // normal versions
            HStack(spacing: 16)
            {
                MainControlButton(
                    icon: "play.fill",
                    label: "Start",
                    color: .green,
                    isCompact: false
                )
                {
                    print("Start tapped")
                }

                MainControlButton(
                    icon: "pause.fill",
                    label: "Pause",
                    color: .orange,
                    isCompact: false
                )
                {
                    print("Pause tapped")
                }
            }

            // compact versions
            Text("Compact Version:")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 16)
            {
                MainControlButton(
                    icon: "play.fill",
                    label: "Start",
                    color: .green,
                    isCompact: true
                )
                {
                    print("Compact Start tapped")
                }

                MainControlButton(
                    icon: "pause.fill",
                    label: "Pause",
                    color: .orange,
                    isCompact: true
                )
                {
                    print("Compact Pause tapped")
                }
            }
        }
        .padding()
    }
}
