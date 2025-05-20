// SwimMate/iOSViews/HomeView/components/DistanceChartCard.swift

import SwiftUI
import Charts

// distance chart card
struct DistanceChartCard: View
{
    @EnvironmentObject var manager: Manager
    @State private var selectedRange: DataRange = .lastTen
    
    enum DataRange: String, CaseIterable {
        case lastTen = "Last 10"
        case lastWeek = "Last Week"
        case allTime = "All Time"
    }
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 12)
        {
            HStack
            {
                Text("Distance Trends")
                    .font(.headline)
                
                Spacer()
                
                Picker("Select Range", selection: $selectedRange)
                {
                    ForEach(DataRange.allCases, id: \.self)
                    { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.menu)
            }
            
            if filteredData.isEmpty
            {
                Text("No data available")
                    .foregroundColor(.secondary)
                    .padding(.vertical, 40)
                    .frame(maxWidth: .infinity)
            }
            else
            {
                Chart
                {
                    ForEach(filteredData)
                    { swim in
                        if let distance = swim.totalDistance
                        {
                            BarMark(
                                x: .value("Date", swim.date, unit: .day),
                                y: .value("Distance", distance)
                            )
                            .foregroundStyle(Color.blue.gradient)
                        }
                    }
                }
                .frame(height: 220)
                .chartYAxis
                {
                    AxisMarks(position: .leading)
                }
                .chartXAxis
                {
                    AxisMarks(values: .stride(by: .day)) {
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day().month(), centered: true)
                    }
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var filteredData: [Swim] {
        switch selectedRange {
        case .lastTen:
            return Array(manager.swims.sorted(by: { $0.date > $1.date }).prefix(10))
        case .lastWeek:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            return manager.swims.filter { $0.date >= oneWeekAgo }
                .sorted(by: { $0.date > $1.date })
        case .allTime:
            return manager.aggregateDataByMonth(swims: manager.swims)
        }
    }
}
