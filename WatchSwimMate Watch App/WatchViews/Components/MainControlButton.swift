// MainControlButton.swift

import SwiftUI

// large main control button for 2x2 grid
struct MainControlButton: View
{
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    @State private var isAnimating = false
    
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
                withAnimation {
                    isAnimating = false
                }
            }
        })
        {
            VStack(spacing: 6)
            {
                ZStack
                {
                    Circle()
                        .fill(color)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: color.opacity(0.3), radius: isAnimating ? 8 : 4, x: 0, y: 2)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(isAnimating ? 0.95 : 1.0)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// preview
#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            MainControlButton(
                icon: "play.fill",
                label: "Start",
                color: .green
            ) {
                print("Start tapped")
            }
            
            MainControlButton(
                icon: "pause.fill",
                label: "Pause",
                color: .orange
            ) {
                print("Pause tapped")
            }
        }
        
        HStack(spacing: 16) {
            MainControlButton(
                icon: "stop.fill",
                label: "Stop",
                color: .red
            ) {
                print("Stop tapped")
            }
            
            MainControlButton(
                icon: "heart.fill",
                label: "Health",
                color: .pink
            ) {
                print("Health tapped")
            }
        }
    }
    .padding()
}
