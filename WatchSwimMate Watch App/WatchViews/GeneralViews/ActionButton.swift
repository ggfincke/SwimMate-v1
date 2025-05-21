// ActionButton

import SwiftUI


// standard button style we'll use throughout the WatchOS component
struct ActionButton: View {
    var label: String
    var icon: String
    var tint: Color
    var compact: Bool = false
    var action: () -> Void
    
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            // haptic feedback
            WKInterfaceDevice.current().play(.click)
            
            // execute action w/ slight delay for animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                action()
                
                // reset button state
                withAnimation {
                    isPressed = false
                }
            }
        })
        {
            HStack(spacing: compact ? 6 : 10) {
                Image(systemName: icon)
                    .font(.system(size: compact ? 14 : 16, weight: .semibold))
                
                Text(label)
                    .font(.system(size: compact ? 14 : 16, weight: .medium, design: .rounded))
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, compact ? 8 : 12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(tint)
                    
                    // highlight effect when pressed
                    if isPressed {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.3))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


// preview
#Preview {
    VStack(spacing: 20) {
        // normal action button
        ActionButton(
            label: "Start Workout",
            icon: "bolt.fill",
            tint: .green
        ) {
            print("Button tapped")
        }
        
        // compact style
        ActionButton(
            label: "Compact Button",
            icon: "heart.fill",
            tint: .pink,
            compact: true
        ) {
            print("Compact button tapped")
        }
    }
    .padding()
}
