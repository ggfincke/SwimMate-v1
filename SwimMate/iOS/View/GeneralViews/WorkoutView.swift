import SwiftUI
import HealthKit

struct WorkoutView: View 
{
    @EnvironmentObject var manager: Manager
    var swim: Swim

    var body: some View 
    {
        ScrollView
        {
            VStack(alignment: .leading, spacing: 20) 
            {
                Text("Swim Details")
                    .font(.largeTitle)
                    .padding(.leading)
                
                Group {
                    Text("Date: \(swim.date, formatter: itemFormatter)")
                        .bold()
                    Text("Duration: \(swim.duration / 60, specifier: "%.0f") minutes")
                    distanceText
                    caloriesText
                    poolLengthText
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
        .padding()
    }

    var distanceText: some View
    {
        if let distance = swim.totalDistance 
        {
            return Text("Total Distance: \(distance, specifier: "%.0f") meters")
        } 
        else
        {
            return Text("Distance data not available")
        }
    }

    var caloriesText: some View
    {
        if let calories = swim.totalEnergyBurned 
        {
            return Text("Calories Burned: \(calories, specifier: "%.0f") kcal")
        } 
        else
        {
            return Text("Calorie data not available")
        }
    }

    var poolLengthText: some View 
    {
        if let poolLength = swim.poolLength 
        {
            return Text("Pool Length: \(formatPoolLength(poolLength))")
        } 
        else
        {
            return Text("Pool Length: Data not available")
        }
    }

    private func formatPoolLength(_ length: Double) -> String
    {
        let unit = manager.preferredUnit
        if unit == .yards 
        {
            let lengthInYards = length * 1.09361 // Conversion from meters to yards
            return String(format: "%.1f yd", lengthInYards)
        } 
        else
        {
            return String(format: "%.1f m", length)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct WorkoutView_Previews: PreviewProvider 
{
    static var previews: some View
    {
        let sampleSwim = Swim(
            id: UUID(),
            date: Date(),
            duration: 3600,
            totalDistance: 1500,
            totalEnergyBurned: 500,
            poolLength: 25.0
        )
        WorkoutView(swim: sampleSwim)
            .environmentObject(Manager())
    }
}
