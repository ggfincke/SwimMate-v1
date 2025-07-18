// SwimMate/iOSViews/SettingsView/PreferencesView.swift

import SwiftUI

struct PreferencesView: View
{
    @EnvironmentObject var manager: Manager
    
    var body: some View 
    {
        Form
        {
            Section(header: Text("Personal Information")) {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("Enter your name", text: $manager.userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                }
                
                HStack {
                    Text("Profile")
                    Spacer()
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
            }
            
            Section(header: Text("Swimming Preferences")) {
                Picker("Preferred Stroke", selection: $manager.preferredStroke) {
                    ForEach([SwimStroke.freestyle, .backstroke, .breaststroke, .butterfly, .mixed], id: \.self) { stroke in
                        HStack {
                            Text(strokeEmoji(for: stroke))
                            Text(stroke.description)
                        }
                        .tag(stroke)
                    }
                }

                Picker("Unit System", selection: $manager.preferredUnit) {
                    ForEach(MeasureUnit.allCases, id: \.self) { unit in
                        HStack {
                            Text(unitEmoji(for: unit))
                            Text(unit.rawValue.capitalized)
                        }
                        .tag(unit)
                    }
                }
                
                Text("Choose your preferred stroke and measurement system")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Current Stats")) {
                HStack {
                    Text("Total Distance")
                    Spacer()
                    Text(manager.formatDistance(manager.totalDistance))
                        .foregroundColor(.blue)
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Total Workouts")
                    Spacer()
                    Text("\(manager.swims.count)")
                        .foregroundColor(.green)
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Average Distance")
                    Spacer()
                    Text(manager.formatDistance(manager.averageDistance))
                        .foregroundColor(.orange)
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Total Calories")
                    Spacer()
                    Text(String(format: "%.0f cal", manager.totalCalories))
                        .foregroundColor(.red)
                        .font(.body)
                        .fontWeight(.semibold)
                }
            }

            Section(header: Text("Actions")) {
                Button("Save Preferences") {
                    savePreferences()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                
                Button("Reset to Defaults") {
                    resetToDefaults()
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Profile & Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func strokeEmoji(for stroke: SwimStroke) -> String {
        return "🏊‍♂️"
    }
    
    private func unitEmoji(for unit: MeasureUnit) -> String {
        switch unit {
        case .meters: return "📏"
        case .yards: return "📐"
        }
    }
    
    private func savePreferences() {
        manager.updateStore()
        
        if manager.hapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
    
    private func resetToDefaults() {
        manager.userName = "User"
        manager.preferredStroke = .freestyle
        manager.preferredUnit = .meters
        manager.updateStore()
        
        if manager.hapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
}



#Preview {
    PreferencesView()
        .environmentObject(Manager())
}

