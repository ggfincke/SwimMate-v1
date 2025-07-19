// SwimMate/iOSViews/SettingsView/NotificationsSettingsView.swift

import SwiftUI
import UserNotifications

struct NotificationsSettingsView: View
{
    @EnvironmentObject var manager: Manager
    @State private var notificationPermissionGranted = false
    
    var body: some View
    {
        Form {
            Section(header: Text("Workout Reminders")) {
                Toggle("Enable Notifications", isOn: $manager.enableNotifications)
                    .onChange(of: manager.enableNotifications) { _, newValue in
                        if newValue {
                            requestNotificationPermission()
                        } else {
                            removeAllNotifications()
                        }
                    }
                
                if manager.enableNotifications {
                    DatePicker("Reminder Time", 
                             selection: $manager.workoutReminderTime,
                             displayedComponents: .hourAndMinute)
                        .onChange(of: manager.workoutReminderTime) { _, _ in
                            scheduleWorkoutReminder()
                        }
                    
                    Text("Daily reminder to swim")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Goal Notifications")) {
                if manager.enableNotifications {
                    Toggle("Weekly Goal Reminders", isOn: .constant(true))
                        .disabled(true)
                    
                    Toggle("Achievement Notifications", isOn: .constant(true))
                        .disabled(true)
                    
                    Text("Get notified when you reach your weekly goals")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Enable notifications to access goal reminders")
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            
            Section(header: Text("App Feedback")) {
                Toggle("Sound Effects", isOn: $manager.soundEnabled)
                
                Toggle("Haptic Feedback", isOn: $manager.hapticFeedback)
                
                Text("Tactile feedback for button presses and actions")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Notification Status")) {
                HStack {
                    Text("Permission Status")
                    Spacer()
                    Text(notificationPermissionGranted ? "Granted" : "Not Granted")
                        .foregroundColor(notificationPermissionGranted ? .green : .red)
                }
                
                if !notificationPermissionGranted {
                    Button("Open Settings") {
                        openAppSettings()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkNotificationPermission()
        }
    }
    
    private func requestNotificationPermission()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                notificationPermissionGranted = granted
                if granted {
                    scheduleWorkoutReminder()
                }
            }
        }
    }
    
    private func checkNotificationPermission()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationPermissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func scheduleWorkoutReminder()
    {
        guard manager.enableNotifications && notificationPermissionGranted else { return }
        
        removeAllNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Swim!"
        content.body = "Don't forget your workout today. Let's crush those goals! 🏊‍♀️"
        content.sound = manager.soundEnabled ? .default : nil
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: manager.workoutReminderTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "workout_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    private func removeAllNotifications()
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["workout_reminder"])
    }
    
    private func openAppSettings()
    {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

#Preview {
    NotificationsSettingsView()
        .environmentObject(Manager())
}