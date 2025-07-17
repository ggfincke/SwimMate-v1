// SwimMate/iOSViews/SwimViews/LogbookView/LogbookView.swift

import SwiftUI

struct LogbookView: View {
    @EnvironmentObject var manager: Manager
    @State private var selectedFilter: TimeFilter = .thirtyDays
    
    enum TimeFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case thirtyDays = "30 Days"
        case ninetyDays = "90 Days"
        case sixMonths = "6 Months"
        case year = "Year"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Filter picker
                Picker("Time Filter", selection: $selectedFilter) {
                    ForEach(TimeFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Filtered workout list
                if filteredWorkouts.isEmpty {
                    ContentUnavailableView(
                        "No Workouts",
                        systemImage: "figure.pool.swim",
                        description: Text("You don't have any recorded swims for this period")
                    )
                    .padding(.top, 40)
                } else {
                    List {
                        ForEach(filteredWorkouts) { swim in
                            NavigationLink(destination: WorkoutView(swim: swim)) {
                                SwimListItemView(swim: swim)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Swim Logbook")
        }
    }
    
    // filtering workouts
    private var filteredWorkouts: [Swim] {
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


#Preview {
    LogbookView()
        .environmentObject(Manager())
}
