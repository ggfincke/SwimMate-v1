// SwimMate/iOSViews/SettingsView/GoalsSettingsView.swift

import SwiftUI

struct GoalsSettingsView: View {
    @EnvironmentObject var manager: Manager
    
    var body: some View {
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
                    Text(formatDistance(getCurrentWeekDistance()))
                        .foregroundColor(.blue)
                        .font(.body.weight(.semibold))
                }
                
                HStack {
                    Text("Current Week Workouts")
                    Spacer()
                    Text("\(getCurrentWeekWorkouts())")
                        .foregroundColor(.green)
                        .font(.body.weight(.semibold))
                }
                
                ProgressView(value: goalProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: goalProgress >= 1.0 ? .green : .blue))
                
                Text(goalProgressText)
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
    
    private func getCurrentWeekDistance() -> Double {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let weeklySwims = manager.swims.filter { $0.startDate >= startOfWeek }
        return weeklySwims.compactMap { $0.totalDistance }.reduce(0, +)
    }
    
    private func getCurrentWeekWorkouts() -> Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return manager.swims.filter { $0.startDate >= startOfWeek }.count
    }
    
    private var goalProgress: Double {
        let distanceProgress = getCurrentWeekDistance() / manager.weeklyGoalDistance
        let workoutProgress = Double(getCurrentWeekWorkouts()) / Double(manager.weeklyGoalWorkouts)
        return min(1.0, max(distanceProgress, workoutProgress))
    }
    
    private var goalProgressText: String {
        let distanceProgress = getCurrentWeekDistance() / manager.weeklyGoalDistance
        let workoutProgress = Double(getCurrentWeekWorkouts()) / Double(manager.weeklyGoalWorkouts)
        
        if distanceProgress >= 1.0 && workoutProgress >= 1.0 {
            return "🎉 Weekly goals achieved!"
        } else if distanceProgress >= 1.0 {
            return "Distance goal achieved! \(manager.weeklyGoalWorkouts - getCurrentWeekWorkouts()) workouts to go."
        } else if workoutProgress >= 1.0 {
            return "Workout goal achieved! \(formatDistance(manager.weeklyGoalDistance - getCurrentWeekDistance())) distance to go."
        } else {
            return "Keep swimming! \(Int(goalProgress * 100))% of weekly goals completed."
        }
    }
    
    private func formatDistance(_ distance: Double) -> String {
        return String(format: "%.0f %@", distance, manager.preferredUnit.rawValue)
    }
}

#Preview {
    GoalsSettingsView()
        .environmentObject(Manager())
}
