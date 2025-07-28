// SwimMate/iOSViews/SwimViews/LogbookView/Sections/LogbookWorkoutListSection.swift

import SwiftUI

struct LogbookWorkoutListSection: View
{
    @EnvironmentObject var manager: Manager
    let displayedWorkouts: [Swim]
    let selectedFilter: LogbookView.TimeFilter
    let searchText: String

    var body: some View
    {
        if displayedWorkouts.isEmpty
        {
            if searchText.isEmpty
            {
                return AnyView(EmptyLogbookView(selectedFilter: selectedFilter))
            }
            else
            {
                return AnyView(SearchEmptyView())
            }
        }
        else
        {
            return AnyView(
                ScrollView
                {
                    LazyVStack(spacing: 12)
                    {
                        ForEach(groupedWorkouts, id: \.key)
                        { group in
                            Section
                            {
                                ForEach(group.value)
                                { swim in
                                    NavigationLink(destination: WorkoutView(swim: swim))
                                    {
                                        LogbookSwimCard(swim: swim)
                                            .environmentObject(manager)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            } header: {
                                SectionHeaderView(title: group.key)
                            }
                        }
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                }
            )
        }
    }

    private var groupedWorkouts: [(key: String, value: [Swim])]
    {
        let grouped = Dictionary(grouping: displayedWorkouts)
        { swim in
            formatSectionHeader(for: swim.date)
        }

        return grouped.sorted
        { first, second in
            // Sort sections by most recent first
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"

            if let firstDate = formatter.date(from: first.key),
               let secondDate = formatter.date(from: second.key)
            {
                return firstDate > secondDate
            }
            return first.key > second.key
        }
    }

    private func formatSectionHeader(for date: Date) -> String
    {
        let calendar = Calendar.current

        if calendar.isDateInToday(date)
        {
            return "Today"
        }
        else if calendar.isDateInYesterday(date)
        {
            return "Yesterday"
        }
        else if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
        {
            return "This Week"
        }
        else
        {
            return date.formatted(.dateTime.month(.wide).year())
        }
    }
}

#Preview
{
    LogbookWorkoutListSection(
        displayedWorkouts: [],
        selectedFilter: .thirtyDays,
        searchText: ""
    )
    .environmentObject(Manager())
}
