// SwimMate/iOSViews/HomeView/HomePage.swift

import SwiftUI
import Charts

struct HomePage: View {
    @EnvironmentObject var manager: Manager
    @Binding var selectedTab: Int
    @State private var showingSettings = false
    @State private var currentTime = Date()
    
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Beautiful gradient background
                LinearGradient(
                    colors: [Color.blue.opacity(0.08), Color.cyan.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // Hero Header
                        heroHeader
                        
                        // Quick Actions
                        quickActionsSection
                        
                        // Stats Overview Cards
                        statsOverviewSection
                        
                        // Recent Activity
                        recentActivitySection
                        
                        // Progress Charts
                        progressChartsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onReceive(timer) { _ in
                currentTime = Date()
            }
        }
        .sheet(isPresented: $showingSettings) {
            NavigationStack {
                SettingsView()
            }
        }
    }
    
    // MARK: - Hero Header
    private var heroHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(greetingMessage)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("Ready to swim?")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Profile/Settings Button
                Button(action: { showingSettings = true }) {
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
            if !todaysSwims.isEmpty {
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
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
                    
                    VStack(spacing: 4) {
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
    
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }
    
    private var todaysSwims: [Swim] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return manager.swims.filter { $0.date >= today && $0.date < tomorrow }
    }
    
    private var todaysTotalDistance: String {
        let total = todaysSwims.compactMap { $0.totalDistance }.reduce(0, +)
        return String(format: "%.0f", total)
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
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
    
    // MARK: - Stats Overview Section
    private var statsOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                HomeStatCard(
                    title: "Workouts",
                    value: "\(weeklyStats.workoutCount)",
                    icon: "figure.pool.swim",
                    color: .blue,
                    trend: weeklyWorkoutTrend
                )
                
                HomeStatCard(
                    title: "Distance",
                    value: weeklyStats.formattedDistance,
                    icon: "ruler",
                    color: .green,
                    trend: weeklyDistanceTrend
                )
                
                HomeStatCard(
                    title: "Time",
                    value: "\(weeklyStats.totalMinutes)m",
                    icon: "clock",
                    color: .orange,
                    trend: weeklyTimeTrend
                )
            }
        }
    }
    
    private var weeklyStats: (workoutCount: Int, totalMinutes: Int, formattedDistance: String) {
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let weeklySwims = manager.swims.filter { $0.date >= lastWeekDate }
        let totalWorkouts = weeklySwims.count
        let totalMinutes = weeklySwims.reduce(0) { $0 + Int($1.duration / 60) }
        let totalDistance = weeklySwims.compactMap { $0.totalDistance }.reduce(0, +)
        
        return (totalWorkouts, totalMinutes, String(format: "%.0f", totalDistance))
    }
    
    private var weeklyWorkoutTrend: StatTrend {
        // Simple trend calculation - in a real app you'd compare to previous week
        let count = weeklyStats.workoutCount
        if count >= 4 { return .up }
        else if count >= 2 { return .neutral }
        else { return .down }
    }
    
    private var weeklyDistanceTrend: StatTrend {
        let distance = weeklyStats.formattedDistance
        if Double(distance) ?? 0 >= 2000 { return .up }
        else if Double(distance) ?? 0 >= 1000 { return .neutral }
        else { return .down }
    }
    
    private var weeklyTimeTrend: StatTrend {
        let minutes = weeklyStats.totalMinutes
        if minutes >= 120 { return .up }
        else if minutes >= 60 { return .neutral }
        else { return .down }
    }
    
    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Swims")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                NavigationLink(destination: LogbookView().environmentObject(manager)) {
                    Text("View All")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            if recentSwims.isEmpty {
                EmptyRecentActivityView()
            } else {
                VStack(spacing: 12) {
                    ForEach(recentSwims.prefix(3)) { swim in
                        NavigationLink(destination: WorkoutView(swim: swim)) {
                            BeautifulSwimRow(swim: swim)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    private var recentSwims: [Swim] {
        return manager.swims.sorted(by: { $0.date > $1.date })
    }
    
    // MARK: - Progress Charts Section
    private var progressChartsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            BeautifulDistanceChart()
                .environmentObject(manager)
        }
    }
}

// MARK: - Supporting Views

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(color)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
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

enum StatTrend {
    case up, down, neutral
    
    var icon: String {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .neutral: return "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return .green
        case .down: return .red
        case .neutral: return .gray
        }
    }
}

struct HomeStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: StatTrend
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: trend.icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(trend.color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
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
}

struct BeautifulSwimRow: View {
    let swim: Swim
    @EnvironmentObject var manager: Manager
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Date circle
            VStack(spacing: 2) {
                Text("\(Calendar.current.component(.day, from: swim.date))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Text(swim.date.formatted(.dateTime.month(.abbreviated)))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(width: 50, height: 50)
            .background(Color.blue)
            .clipShape(Circle())
            
            // Swim details
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(swim.date.formatted(.dateTime.hour().minute()))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if let distance = swim.totalDistance, distance > 0 {
                        Text(manager.formatDistance(distance))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
                
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Text(formatDuration(swim.duration))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let strokes = getStrokes(from: swim) {
                        Text(strokes)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
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

struct EmptyRecentActivityView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.pool.swim")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 4) {
                Text("No recent swims")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Start your first workout to see your activity here")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

struct BeautifulDistanceChart: View {
    @EnvironmentObject var manager: Manager
    @State private var selectedRange: DataRange = .last30Days
    
    enum DataRange: String, CaseIterable {
        case last30Days = "30D"
        case last6Months = "6M"
        case lastYear = "1Y"
        
        var fullName: String {
            switch self {
            case .last30Days: return "Last 30 Days"
            case .last6Months: return "Last 6 Months"
            case .lastYear: return "Last Year"
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Distance Trends")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(DataRange.allCases, id: \.self) { range in
                        Button(action: { selectedRange = range }) {
                            Text(range.rawValue)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(selectedRange == range ? .white : .secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedRange == range ? Color.blue : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            if filteredData.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 24))
                        .foregroundColor(.secondary.opacity(0.6))
                    
                    Text("No data for \(selectedRange.fullName.lowercased())")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
            } else {
                Chart(filteredData) { swim in
                    if let distance = swim.totalDistance {
                        LineMark(
                            x: .value("Date", swim.date),
                            y: .value("Distance", distance)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: CGLineCap.round))
                        
                        AreaMark(
                            x: .value("Date", swim.date),
                            y: .value("Distance", distance)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .cyan.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .frame(height: 120)
                .chartYAxis(.hidden)
                .chartXAxis(.hidden)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
    
    private var filteredData: [Swim] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date? = {
            switch selectedRange {
            case .last30Days:
                return calendar.date(byAdding: .day, value: -30, to: now)
            case .last6Months:
                return calendar.date(byAdding: .month, value: -6, to: now)
            case .lastYear:
                return calendar.date(byAdding: .year, value: -1, to: now)
            }
        }()
        
        if let startDate = startDate {
            return manager.swims.filter { $0.date >= startDate }.sorted { $0.date < $1.date }
        } else {
            return manager.swims.sorted { $0.date < $1.date }
        }
    }
}

#Preview {
    HomePage(selectedTab: .constant(0))
        .environmentObject(Manager())
}
