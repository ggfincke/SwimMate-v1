// SwimMate/iOSViews/HomeView/components/DistanceChartCard.swift

import SwiftUI
import Charts

private func makeAggregatedSwim(date: Date, duration: Double, totalDistance: Double?, totalEnergyBurned: Double?) -> Swim {
    return Swim(
        id: UUID(),
        date: date,
        duration: duration,
        totalDistance: totalDistance,
        totalEnergyBurned: totalEnergyBurned,
        poolLength: nil,
        laps: []
    )
}

// distance chart card w/ expanded date ranges & improved visualization
struct DistanceChartCard: View 
{
    @EnvironmentObject var manager: Manager
    @State private var selectedRange: DataRange = .last30Days
    
    enum DataRange: String, CaseIterable 
    {
        case last30Days = "Last 30 Days"
        case last6Months = "Last 6 Months"
        case lastYear = "Last Year"
        case allTime = "All Time"
    }
    
    var body: some View 
    {
        VStack(alignment: .leading, spacing: 16) 
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
                VStack(spacing: 12) 
                {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary.opacity(0.6))
                    
                    Text("No swim data available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Start swimming to see your trends!")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.8))
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
            } 
            else 
            {
                Chart(filteredData) 
                { swim in
                    if let distance = swim.totalDistance 
                    {
                        LineMark(
                            x: .value("Date", swim.date),
                            y: .value("Distance", distance)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                }

                .frame(height: 220)
                .chartYAxis {
                    AxisMarks { value in
                        if let distance = value.as(Double.self) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel() {
                                Text(manager.formatDistance(distance))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel() {
                            if let date = value.as(Date.self) {
                                Text(formatAxisLabel(date))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var filteredData: [Swim] 
    {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date? = {
            switch selectedRange 
            {
                case .last30Days:
                    return calendar.date(byAdding: .day, value: -30, to: now)
                case .last6Months:
                    return calendar.date(byAdding: .month, value: -6, to: now)
                case .lastYear:
                    return calendar.date(byAdding: .year, value: -1, to: now)
                case .allTime:
                    return nil
            }
        }()
        
        var swimsToProcess: [Swim]
        
        if let startDate = startDate 
        {
            swimsToProcess = manager.swims.filter { $0.date >= startDate }
        } 
        else 
        {
            swimsToProcess = manager.swims
        }
        
        switch selectedRange 
        {
            case .last30Days:
                return aggregateSwimsByWeek(swimsToProcess)
            case .last6Months, .lastYear:
                return manager.aggregateDataByMonth(swims: swimsToProcess)
            case .allTime:
                return aggregateSwimsByQuarter(swimsToProcess)
        }
    }
    
    private func aggregateSwimsByWeek(_ swims: [Swim]) -> [Swim] 
    {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: swims)
        { swim in
            calendar.dateInterval(of: .weekOfYear, for: swim.date)?.start ?? swim.date
        }
        return grouped.map { (week, swimmers) in
            let duration = swimmers.reduce(0) { $0 + $1.duration }
            let totalDistance = swimmers.compactMap { $0.totalDistance }.reduce(0, +)
            let totalEnergyBurned = swimmers.compactMap { $0.totalEnergyBurned }.reduce(0, +)
            return makeAggregatedSwim(date: week, duration: duration, totalDistance: totalDistance, totalEnergyBurned: totalEnergyBurned)
        }.sorted { $0.date < $1.date }
    }
    
    private func aggregateSwimsByQuarter(_ swims: [Swim]) -> [Swim] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: swims) { swim in
            let comps = calendar.dateComponents([.year, .month], from: swim.date)
            let year = comps.year ?? 1970
            let quarter = ((comps.month ?? 1) - 1) / 3 + 1
            let quarterMonth = (quarter - 1) * 3 + 1
            return calendar.date(from: DateComponents(year: year, month: quarterMonth)) ?? swim.date
        }
        return grouped.map { (quarter, swimmers) in
            let duration = swimmers.reduce(0) { $0 + $1.duration }
            let totalDistance = swimmers.compactMap { $0.totalDistance }.reduce(0, +)
            let totalEnergyBurned = swimmers.compactMap { $0.totalEnergyBurned }.reduce(0, +)
            return makeAggregatedSwim(date: quarter, duration: duration, totalDistance: totalDistance, totalEnergyBurned: totalEnergyBurned)
        }.sorted { $0.date < $1.date }
    }
    
    private func formatAxisLabel(_ date: Date) -> String {
        switch selectedRange 
        {
            case .last30Days:
                return date.formatted(.dateTime.month().day())
            case .last6Months, .lastYear:
                return date.formatted(.dateTime.month())
            case .allTime:
                return date.formatted(.dateTime.year())
        }
    }
}

#Preview {
    let manager = Manager()
    return DistanceChartCard().environmentObject(manager)
}
