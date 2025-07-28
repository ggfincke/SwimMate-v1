// CelebrationOverlay.swift

import SwiftUI

// CelebrationOverlay
struct CelebrationOverlay: View

{
    @State private var particles: [ParticleEffect] = []

    struct ParticleEffect: Identifiable
    {
        let id = UUID()
        var x: Double
        var y: Double
        var opacity: Double = 1.0
        var scale: Double = 1.0
    }

    var body: some View
    {
        ZStack
        {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 16)
            {
                Text("🎉")
                    .font(.system(size: 40))

                Text("Outstanding!")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("You completed an amazing workout!")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
            )
        }
    }
}

// preview
#Preview
{
    CelebrationOverlay()
}
