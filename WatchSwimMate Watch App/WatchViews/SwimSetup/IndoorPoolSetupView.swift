// IndoorPoolSetupView.swift

import SwiftUI

// sets up a pool workout
struct IndoorPoolSetupView: View 
{
    @Environment(WatchManager.self) private var manager

    // swim set optional (if importing)
    var swimmySet: SwimSet?
    
    // standard pool lengths
    private let standardLengths = [25.0, 50.0]
    
    // state var for animating rotating button
    @State private var rotationAngle: Double = 0

    var body: some View
    {
        VStack(spacing: 16)
        {
            // pool length display w/ digital crown support
            VStack(spacing: 8) 
            {
                HStack(alignment: .lastTextBaseline, spacing: 8) 
                {
                    Text("\(Int(manager.poolLength))")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Text(manager.poolUnit == "meters" ? "m" : "yd")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.blue)
                        .opacity(0.8)
                }
                .focusable(true)
                .digitalCrownRotation(
                    Binding(
                        get: { manager.poolLength },
                        set: { manager.poolLength = $0 }
                    ),
                    from: 10,
                    through: 100,
                    by: 1,
                    sensitivity: .medium,
                    isContinuous: false
                )
                .onChange(of: manager.poolLength) { oldValue, newValue in
                    print("🔄 Digital Crown: Pool length changed from \(oldValue) to \(newValue)")
                }
                
                Text("Use Digital Crown to adjust")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .opacity(0.8)
            }
            .padding(.top, 8)
            
            // standard pool lengths & unit selection
            HStack(spacing: 10) 
            {
                ForEach(standardLengths, id: \.self) 
                { length in
                    Button 
                    {
                        print("🏊‍♂️ Standard length button pressed: \(Int(length))")
                        WKInterfaceDevice.current().play(.click)
                        manager.poolLength = length
                        print("📏 Pool length set to: \(manager.poolLength)")
                    } 
                    label: 
                    {
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
                Button 
                {
                    // only allow unit changes if goal unit is not locked
                    guard !manager.goalUnitLocked else { 
                        WKInterfaceDevice.current().play(.failure)
                        return 
                    }
                    
                    let oldUnit = manager.poolUnit
                    print("🔄 Unit toggle button pressed - Current unit: \(oldUnit)")
                    withAnimation(.easeInOut(duration: 0.3)) 
                    {
                        rotationAngle += 180
                        manager.poolUnit = manager.poolUnit == "meters" ? "yards" : "meters"
                        
                        // sync goal unit with pool unit if not locked
                        if !manager.goalUnitLocked {
                            manager.goalUnit = manager.poolUnit
                        }
                    }
                    print("📐 Unit changed from \(oldUnit) to \(manager.poolUnit)")
                    WKInterfaceDevice.current().play(.click)
                } 
                label: 
                {
                    Image(systemName: manager.goalUnitLocked ? "lock.fill" : "arrow.2.circlepath")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(manager.goalUnitLocked ? .red : .blue)
                        .rotationEffect(.degrees(manager.goalUnitLocked ? 0 : rotationAngle))
                        .frame(width: 40, height: 35)
                        .background(Color.secondary.opacity(0.15))
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(manager.goalUnitLocked)
                .opacity(manager.goalUnitLocked ? 0.6 : 1.0)
            }
            
            // start workout button
            ActionButton(
                label: "Start Workout",
                icon: "play.fill",
                tint: .green,
                compact: true
            ) 
            {
                manager.startWorkout()
                
                if let swimmySet = swimmySet 
                {
                    manager.path.append(NavState.swimmingView(set: swimmySet))
                } 
                else 
                {
                    manager.path.append(NavState.swimmingView(set: nil))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)

    }
}

#Preview
{
    IndoorPoolSetupView()
        .environment(WatchManager())
}
