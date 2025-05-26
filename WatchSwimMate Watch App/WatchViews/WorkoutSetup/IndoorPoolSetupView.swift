// IndoorPoolSetupView.swift

import SwiftUI

struct IndoorPoolSetupView: View {
    @EnvironmentObject var manager: WatchManager
    
    // swim set optional (if importing)
    var swimmySet: SwimSet?
    
    // standard pool lengths
    private let standardLengths = [25.0, 50.0]
    
    // state var for animating rotating button
    @State private var rotationAngle: Double = 0

    var body: some View {
        VStack(spacing: 16) {
            // pool length display with digital crown support
            VStack(spacing: 8) {
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text("\(Int(manager.poolLength))")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Text(manager.poolUnit == "meters" ? "m" : "yd")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.blue)
                        .opacity(0.8)
                }
                .digitalCrownRotation(
                    $manager.poolLength,
                    from: 10,
                    through: 100,
                    by: 1,
                    sensitivity: .medium,
                    isContinuous: false
                )
                
                Text("Use Digital Crown to adjust")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .opacity(0.8)
            }
            .padding(.top, 8)
            
            // standard pool lengths and unit selection
            HStack(spacing: 10) {
                ForEach(standardLengths, id: \.self) { length in
                    Button {
                        WKInterfaceDevice.current().play(.click)
                        manager.poolLength = length
                    } label: {
                        Text("\(Int(length))")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(manager.poolLength == length ? .white : .primary)
                            .frame(width: 45, height: 35)
                            .background(
                                manager.poolLength == length
                                ? Color.blue
                                : Color.secondary.opacity(0.15)
                            )
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // unit selection button
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        rotationAngle += 180
                        manager.poolUnit = manager.poolUnit == "meters" ? "yards" : "meters"
                    }
                    WKInterfaceDevice.current().play(.click)
                } label: {
                    Image(systemName: "arrow.2.circlepath")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(rotationAngle))
                        .frame(width: 40, height: 35)
                        .background(Color.secondary.opacity(0.15))
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // start workout button
            ActionButton(
                label: "Start Workout",
                icon: "play.fill",
                tint: .green,
                compact: true
            ) {
                manager.startWorkout()
                
                if let swimmySet = swimmySet {
                    manager.path.append(NavState.swimmingView(set: swimmySet))
                } else {
                    manager.path.append(NavState.swimmingView(set: nil))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    IndoorPoolSetupView()
        .environmentObject(WatchManager())
}
