// SwimMate/iOSViews/HomeView/Sections/QuickActionsSection.swift

import SwiftUI

struct QuickActionsSection: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                Button(action: { selectedTab = 1 }) {
                    VStack(spacing: 12) {
                        Image(systemName: "list.bullet.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 4) {
                            Text("Browse Sets")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Find workouts")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { selectedTab = 2 }) {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.green)
                        
                        VStack(spacing: 4) {
                            Text("Swim History")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("View logbook")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}