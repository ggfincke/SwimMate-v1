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
                        HomeHeroSection(showingSettings: $showingSettings, currentTime: currentTime)
                            .environmentObject(manager)
                        
                        // Quick Actions
                        QuickActionsSection(selectedTab: $selectedTab)
                        
                        // Stats Overview Cards
                        WeeklyStatsSection()
                            .environmentObject(manager)
                        
                        // Recent Activity
                        RecentActivitySection(selectedTab: $selectedTab)
                            .environmentObject(manager)
                        
                        // Progress Charts
                        ProgressChartsSection()
                            .environmentObject(manager)
                        
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
}

// MARK: - Supporting Views

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