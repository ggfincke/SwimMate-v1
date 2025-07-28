// SwimMate/iOSViews/HomeView/Sections/HomeHeroSection.swift

import SwiftUI

struct HomeHeroSection: View
{
    @EnvironmentObject var manager: Manager
    @Binding var showingSettings: Bool
    let currentTime: Date

    var body: some View
    {
        VStack(spacing: 16)
        {
            HStack
            {
                VStack(alignment: .leading, spacing: 8)
                {
                    Text(greetingMessage)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.secondary)

                    Text("Ready to swim?")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }

                Spacer()

                // Profile/Settings Button
                Button(action: { showingSettings = true })
                {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.blue)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        )
                }
            }

            // Today's stats preview
            if !todaysSwims.isEmpty
            {
                HStack(spacing: 16)
                {
                    VStack(spacing: 4)
                    {
                        Text("Today")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("\(todaysSwims.count)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue)
                        Text("workouts")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    Divider()
                        .frame(height: 40)

                    VStack(spacing: 4)
                    {
                        Text("Distance")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(todaysTotalDistance)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.green)
                        Text(manager.preferredUnit.rawValue)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.7))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
        }
        .padding(.top, 20)
    }

    private var greetingMessage: String
    {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour
        {
        case 5 ..< 12: return "Good morning"
        case 12 ..< 17: return "Good afternoon"
        case 17 ..< 22: return "Good evening"
        default: return "Good night"
        }
    }

    private var todaysSwims: [Swim]
    {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return manager.swims.filter
        { $0.date >= today && $0.date < tomorrow }
    }

    private var todaysTotalDistance: String
    {
        let total = todaysSwims.compactMap
        { $0.totalDistance }.reduce(0, +)
        return String(format: "%.0f", total)
    }
}

#Preview
{
    HomeHeroSection(showingSettings: .constant(false), currentTime: Date())
        .environmentObject(Manager())
}
