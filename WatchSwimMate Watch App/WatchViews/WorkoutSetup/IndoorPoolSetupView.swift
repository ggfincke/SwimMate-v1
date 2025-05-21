// IndoorPoolSetupView

import SwiftUI

struct IndoorPoolSetupView: View {
    @EnvironmentObject var manager: WatchManager
    
    // swim set optional (if importing)
    var swimmySet: SwimSet?
    
    // standard pool lengths
    private let standardLengths = [25.0, 50.0]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // pool length display
                VStack(spacing: 6) {
                    Text("Pool Length")
                        .font(.headline)
                    
                    Text("\(Int(manager.poolLength)) \(manager.poolUnit)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)
                
                // pool length adjustment
                HStack(spacing: 20) {
                    // Decrease button
                    Button {
                        if manager.poolLength > 10 {
                            WKInterfaceDevice.current().play(.click)
                            manager.poolLength -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Increase button
                    Button {
                        WKInterfaceDevice.current().play(.click)
                        manager.poolLength += 1
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 40)
                
                // standard pool length options
                VStack(spacing: 10) {
                    Text("Standard Lengths")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 10) {
                        ForEach(standardLengths, id: \.self) { length in
                            Button {
                                WKInterfaceDevice.current().play(.click)
                                manager.poolLength = length
                            } label: {
                                Text("\(Int(length))")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(manager.poolLength == length ? .white : .primary)
                                    .frame(minWidth: 44, minHeight: 32)
                                    .background(manager.poolLength == length ? Color.blue : Color.secondary.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // unit selection
                Button {
                    // Toggle between meters and yards
                    manager.poolUnit = manager.poolUnit == "meters" ? "yards" : "meters"
                    WKInterfaceDevice.current().play(.click)
                } label: {
                    HStack {
                        Text("Unit:")
                            .font(.body)
                        
                        Text(manager.poolUnit.capitalized)
                            .font(.body)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 8)
                
                Spacer()
                
                // start workout button
                Button {
                    WKInterfaceDevice.current().play(.success)
                    manager.startWorkout()
                    
                    // navigate to swimming view with or without a swim set
                    if let swimmySet = swimmySet {
                        manager.path.append(NavState.swimmingView(set: swimmySet))
                    } else {
                        manager.path.append(NavState.swimmingView(set: nil))
                    }
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Workout")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green)
                    .cornerRadius(14)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationTitle("Pool Setup")
    }
}

#Preview {
    IndoorPoolSetupView()
        .environmentObject(WatchManager())
}
