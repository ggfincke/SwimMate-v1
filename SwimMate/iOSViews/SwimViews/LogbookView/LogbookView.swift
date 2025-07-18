// SwimMate/iOSViews/SwimViews/LogbookView/LogbookView.swift

import SwiftUI

struct LogbookView: View {
    @EnvironmentObject var manager: Manager
    @State private var selectedFilter: TimeFilter = .thirtyDays
    @State private var searchText = ""
    
    enum TimeFilter: String, CaseIterable, Identifiable {
        case all = "All Time"
        case thirtyDays = "30 Days"
        case ninetyDays = "90 Days"
        case sixMonths = "6 Months"
        case year = "Year"
        
        var id: String { self.rawValue }
        
        var shortName: String {
            switch self {
            case .all: return "All"
            case .thirtyDays: return "30D"
            case .ninetyDays: return "90D"
            case .sixMonths: return "6M"
            case .year: return "1Y"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Beautiful gradient background
                LinearGradient(
                    colors: [Color.green.opacity(0.08), Color.blue.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header Section
                    LogbookHeaderSection(searchText: $searchText, filteredWorkoutsCount: filteredWorkouts.count)
                        .environmentObject(manager)
                    
                    // Filter Section
                    LogbookFilterSection(selectedFilter: $selectedFilter)
                    
                    // Stats Summary
                    if !filteredWorkouts.isEmpty {
                        LogbookStatsSection(filteredWorkouts: filteredWorkouts)
                            .environmentObject(manager)
                    }
                    
                    // Workout List
                    LogbookWorkoutListSection(
                        displayedWorkouts: displayedWorkouts,
                        selectedFilter: selectedFilter,
                        searchText: searchText
                    )
                    .environmentObject(manager)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Data Processing
    private var displayedWorkouts: [Swim] {
        var workouts = filteredWorkouts
        
        if !searchText.isEmpty {
            workouts = workouts.filter { swim in
                // Search by date, duration, or stroke type
                let dateString = swim.date.formatted(.dateTime.weekday().month().day())
                let durationString = formatDuration(swim.duration)
                let strokesString = getStrokes(from: swim) ?? ""
                
                return dateString.localizedCaseInsensitiveContains(searchText) ||
                       durationString.localizedCaseInsensitiveContains(searchText) ||
                       strokesString.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return workouts
    }
    
    // MARK: - Helper Functions
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    private func getStrokes(from swim: Swim) -> String? {
        let uniqueStrokes = Set(swim.laps.compactMap { $0.stroke?.description })
        if uniqueStrokes.isEmpty {
            return nil
        }
        return uniqueStrokes.joined(separator: ", ")
    }
}

// MARK: - Extension for filteredWorkouts
extension LogbookView {
    var filteredWorkouts: [Swim] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let dateLimit: Date? = {
            switch selectedFilter {
            case .thirtyDays:
                return calendar.date(byAdding: .day, value: -30, to: currentDate)
            case .ninetyDays:
                return calendar.date(byAdding: .day, value: -90, to: currentDate)
            case .sixMonths:
                return calendar.date(byAdding: .month, value: -6, to: currentDate)
            case .year:
                return calendar.date(byAdding: .year, value: -1, to: currentDate)
            case .all:
                return nil
            }
        }()
        
        if let dateLimit = dateLimit {
            return manager.swims.filter { $0.date >= dateLimit }
                .sorted(by: { $0.date > $1.date })
        } else {
            return manager.swims.sorted(by: { $0.date > $1.date })
        }
    }
}

// MARK: - Supporting Views

struct TimeFilterChip: View {
    let filter: LogbookView.TimeFilter
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(filter.shortName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.green : Color(UIColor.systemGray6))
                .cornerRadius(20)
                .shadow(color: .black.opacity(isSelected ? 0.15 : 0.05), radius: isSelected ? 6 : 2, x: 0, y: isSelected ? 3 : 1)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct LogbookStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct LogbookSwimCard: View {
    let swim: Swim
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        HStack(spacing: 16) {
            // Date and time circle
            VStack(spacing: 2) {
                Text("\(Calendar.current.component(.day, from: swim.date))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Text(swim.date.formatted(.dateTime.month(.abbreviated)))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(width: 50, height: 50)
            .background(Color.green)
            .clipShape(Circle())
            
            // Swim details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(swim.date.formatted(.dateTime.hour().minute()))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if let distance = swim.totalDistance, distance > 0 {
                        Text(manager.formatDistance(distance))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Text(formatDuration(swim.duration))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    if let strokes = getStrokes(from: swim) {
                        HStack(spacing: 4) {
                            Image(systemName: "figure.pool.swim")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            
                            Text(strokes)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                }
            }
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    private func getStrokes(from swim: Swim) -> String? {
        let uniqueStrokes = Set(swim.laps.compactMap { $0.stroke?.description })
        if uniqueStrokes.isEmpty {
            return nil
        }
        return uniqueStrokes.joined(separator: ", ")
    }
}

struct EmptyLogbookView: View {
    let selectedFilter: LogbookView.TimeFilter
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.pool.swim")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No swims recorded")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("No swim workouts found for \(selectedFilter.rawValue.lowercased())")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

struct SearchEmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No results found")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Try adjusting your search terms")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

#Preview {
    LogbookView()
        .environmentObject(Manager())
}