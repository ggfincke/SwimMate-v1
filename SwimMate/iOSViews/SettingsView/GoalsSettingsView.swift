// SwimMate/iOSViews/SettingsView/GoalsSettingsView.swift

import SwiftUI

struct GoalsSettingsView: View
{
    @EnvironmentObject var manager: Manager
    
    var body: some View
    {
        Form {
            Section(header: Text("Weekly Goals")) {
                HStack {
                    Text("Distance Goal")
                    Spacer()
                    TextField("Distance", value: $manager.weeklyGoalDistance, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                    Text(manager.preferredUnit.rawValue)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Workout Goal")
                    Spacer()
                    TextField("Workouts", value: $manager.weeklyGoalWorkouts, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                    Text("workouts")
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Progress")) {
                HStack {
                    Text("Current Week Distance")
                    Spacer()
                    Text(manager.formatDistance(manager.getCurrentWeekDistance()))
                        .foregroundColor(.blue)
                        .font(.body.weight(.semibold))
                }
                
                HStack {
                    Text("Current Week Workouts")
                    Spacer()
                    Text("\(manager.getCurrentWeekWorkouts())")
                        .foregroundColor(.green)
                        .font(.body.weight(.semibold))
                }
                
                ProgressView(value: manager.goalProgress(), total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: manager.goalProgress() >= 1.0 ? .green : .blue))
                
                Text(manager.goalProgressText())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Pool Settings")) {
                HStack {
                    Text("Pool Length")
                    Spacer()
                    TextField("Length", value: $manager.poolLength, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                    Text(manager.preferredUnit.rawValue)
                        .foregroundColor(.secondary)
                }
                
                Text("Used for calculating laps and distances")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Save Settings")) {
                Button("Save Goals") {
                    manager.updateStore()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Goals & Pool")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GoalsSettingsView()
        .environmentObject(Manager())
}
