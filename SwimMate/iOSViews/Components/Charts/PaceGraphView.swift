// SwimMate/iOSViews/Components/Charts/PaceGraphView.swift

import Charts
import SwiftUI

struct PaceGraphView: View
{
    @EnvironmentObject var manager: Manager
    @State private var selectedRange: TimeRange = .threeMonths

    var body: some View
    {
        VStack
        {
            Text("Pace (\(unitLabel)/sec)")
                .font(.title2)

            Picker("Time Range", selection: $selectedRange)
            {
                ForEach(TimeRange.allCases, id: \.self)
                { range in
                    Text(range.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Chart(filteredData, id: \.id)
            { swim in
                if let pace = swim.pacePer100(preferredUnit: manager.preferredUnit)
                {
                    LineMark(
                        x: .value("Date", swim.date),
                        y: .value("Pace (sec/100\(unitLabel))", pace)
                    )
                }
            }

            .chartXAxis
            {
                AxisMarks(values: .stride(by: .month))
                {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month().year(), centered: true)
                }
            }
            .chartYAxis
            {
                AxisMarks(position: .leading)
                {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
        }
    }

    private var unitLabel: String
    {
        manager.preferredUnit == .yards ? "yd" : "m"
    }

    private var filteredData: [Swim]
    {
        let calendar = Calendar.current
        let dateMonthsAgo: Date
        switch selectedRange
        {
        case .threeMonths:
            dateMonthsAgo = calendar.date(byAdding: .month, value: -3, to: Date())!
        case .sixMonths:
            dateMonthsAgo = calendar.date(byAdding: .month, value: -6, to: Date())!
        case .twelveMonths:
            dateMonthsAgo = calendar.date(byAdding: .month, value: -12, to: Date())!
        }
        return manager.swims.filter { $0.date >= dateMonthsAgo }
    }

    enum TimeRange: String, CaseIterable
    {
        case threeMonths = "3 Months"
        case sixMonths = "6 Months"
        case twelveMonths = "12 Months"
    }

    private func paceLabel(_ pace: TimeInterval) -> String
    {
        let distanceUnit = manager.preferredUnit == .yards ? "yd" : "m"
        let paceLabel = manager.preferredUnit == .yards ? pace * 1.09361 : pace
        return String(format: "Pace (sec/100\(distanceUnit))", paceLabel)
    }
}

// extending swim class
extension Swim
{
    func pacePer100(preferredUnit: MeasureUnit) -> Double?
    {
        guard let totalDistance = totalDistance, totalDistance > 0, duration > 0 else { return nil }

        // Calculate pace per second for the distance unit that the swim was recorded in
        let pacePerSecond = totalDistance / duration

        // Convert pace to per-100 unit
        let pacePer100 = pacePerSecond * 100

        // If the swim was recorded in a different unit than the preferred display unit, convert
        if poolUnit == .yards, preferredUnit == .meters
        {
            return pacePer100 / 1.09361 // convert yards pace to meters pace
        }
        else if poolUnit == .meters, preferredUnit == .yards
        {
            return pacePer100 * 1.09361 // convert meters pace to yards pace
        }
        else
        {
            return pacePer100 // no conversion needed
        }
    }
}

#Preview
{
    PaceGraphView()
        .environmentObject(Manager())
}
