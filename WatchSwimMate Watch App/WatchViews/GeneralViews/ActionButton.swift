// actionbutton

import SwiftUI

// action button
struct ActionButton: View {
    var label: String
    var icon: String
    var tint: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(label)
            }
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .clipShape(Capsule())
    }
}

// preview
#Preview {
    ActionButton(
        label: "Preview",
        icon: "star.fill",
        tint: .purple
    ) {
        print("Preview tapped")
    }
    .padding()
}
