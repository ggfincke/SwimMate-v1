// SwimMate/iOSViews/SettingsView/SettingsView.swift

import SwiftUI

struct SettingsView: View 
{
    @EnvironmentObject var manager: Manager
    
    var body: some View 
    {
        List
        {
            Section(header: Text("Personal")) {
                NavigationLink(destination: PreferencesView()) {
                    SettingsRow(icon: "person.circle.fill", title: "Profile & Preferences", color: .blue)
                }
                
                NavigationLink(destination: GoalsSettingsView()) {
                    SettingsRow(icon: "target", title: "Goals & Pool", color: .green)
                }
            }
            
            Section(header: Text("App Experience")) {
                NavigationLink(destination: NotificationsSettingsView()) {
                    SettingsRow(icon: "bell.fill", title: "Notifications", color: .red)
                }
                
                NavigationLink(destination: AppSettingsView()) {
                    SettingsRow(icon: "gear", title: "App Settings", color: .gray)
                }
            }
            
            Section(header: Text("Data & Privacy")) {
                NavigationLink(destination: HealthKitPermissionView()) {
                    SettingsRow(icon: "heart.fill", title: "HealthKit", color: .pink)
                }
                
                NavigationLink(destination: DataPrivacySettingsView()) {
                    SettingsRow(icon: "lock.shield.fill", title: "Data & Privacy", color: .purple)
                }
            }
            
            Section(header: Text("Quick Actions")) {
                Button(action: {
                    triggerHapticFeedback()
                }) {
                    SettingsRow(icon: "arrow.clockwise", title: "Sync Data", color: .orange)
                }
                .foregroundColor(.primary)
                
                Button(action: {
                    openAppInAppStore()
                }) {
                    SettingsRow(icon: "star.fill", title: "Rate App", color: .yellow)
                }
                .foregroundColor(.primary)
            }
            
            Section(header: Text("Support")) {
                Button(action: {
                    sendSupportEmail()
                }) {
                    SettingsRow(icon: "envelope.fill", title: "Contact Support", color: .blue)
                }
                .foregroundColor(.primary)
                
                Button(action: {
                    openUserGuide()
                }) {
                    SettingsRow(icon: "book.fill", title: "User Guide", color: .indigo)
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("Settings")
        .listStyle(GroupedListStyle())
    }
    
    private func triggerHapticFeedback()
    {
        if manager.hapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
        // In a real app, this would trigger a data sync
    }
    
    private func openAppInAppStore()
    {
        if let url = URL(string: "https://apps.apple.com/app/swimmate") {
            UIApplication.shared.open(url)
        }
    }
    
    private func sendSupportEmail()
    {
        if let url = URL(string: "mailto:support@swimmate.app") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openUserGuide()
    {
        if let url = URL(string: "https://swimmate.app/guide") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View
{
    let icon: String
    let title: String
    let color: Color
    
    var body: some View
    {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .cornerRadius(6)
            
            Text(title)
                .font(.body)
            
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider 
{
    static var previews: some View 
    {
        SettingsView()
    }
}


#Preview {
    SettingsView()
}
