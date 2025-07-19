// SwimMate/ViewModel/Manager.swift

// the iOS manager/view model
import Foundation
import HealthKit
import SwiftUI

enum LocationType: String, Codable
{
    case unknown
}

struct AnyCodable: Codable 
{
}

enum AppTheme: String, CaseIterable
{
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var displayName: String
    {
        return self.rawValue
    }
}

class Manager: NSObject, ObservableObject
{
    //MARK: vars / init
    // healthkit vars
    var permission: Bool
    let healthStore: HKHealthStore
    var currentWorkoutSession: HKWorkoutSession?
    
    // user preferences
    @Published var userName: String = "User"
    @Published var preferredStroke: SwimStroke = .freestyle
    @Published var preferredUnit: MeasureUnit = .meters
    @Published var swims: [Swim] = []
    
    // new settings
    @Published var enableNotifications: Bool = true
    @Published var workoutReminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var weeklyGoalDistance: Double = 2000.0
    @Published var weeklyGoalWorkouts: Int = 3
    @Published var autoSync: Bool = true
    @Published var soundEnabled: Bool = true
    @Published var hapticFeedback: Bool = true
    @Published var poolLength: Double = 50.0
    @Published var privacyMode: Bool = false
    @Published var dataExportEnabled: Bool = true
    @Published var appTheme: AppTheme = .system
    @Published var chartDisplayDays: Int = 30

    // filter state
    @Published var activeFilters = Manager.SetFilters.defaultFilters
    @Published var favoriteSetIds: Set<UUID> = []

    // store
    @Published var store: Store = Store(userName: "Default User", preferredStroke: .freestyle, preferredUnit: .meters, swims: [])

    // user totals (calculated values)
    @Published var totalDistance: Double = 0.0
    @Published var averageDistance: Double = 0.0
    @Published var totalCalories: Double = 0.0
    @Published var averageCalories: Double = 0.0

    
    //TODO: replace with database integration at some point
    // very long list of sample sets
    let sampleSets: [SwimSet] = [
        SwimSet(title: "Endurance Challenge", components: [
            SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30, descend 1-5, 6-10"),
            SetComponent(type: .kick, distance: 500, strokeStyle: .kickboard, instructions: "10x50 kick on 1:00"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down easy")
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.intermediate, description: "A challenging endurance set to boost stamina."),
        SwimSet(title: "Technique Tuner", components: [
            SetComponent(type: .swim, distance: 200, strokeStyle: .breaststroke, instructions: "200 swim, 200 pull, 200 kick"),
            SetComponent(type: .drill, distance: 500, strokeStyle: .breaststroke, instructions: "10x50 on 50s, odds drill, evens swim"),
            SetComponent(type: .pull, distance: 400, strokeStyle: .breaststroke, instructions: "4x100 pull with paddles on 1:40"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy")
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.advanced, description: "Focus on technique and power."),
        SwimSet(title: "Backstroke Blast", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .backstroke, instructions: "4x100 backstroke on 2:00"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .backstroke, instructions: "8x50 back fast on 1:00"),
            SetComponent(type: .swim, distance: 100, strokeStyle: .backstroke, instructions: "4x25 sprint on 30s"),
            SetComponent(type: .cooldown, distance: 300, strokeStyle: .mixed, instructions: "300 easy")
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.beginner, description: "Speed work for improving backstroke performance."),
        SwimSet(title: "Butterfly Sprint Series", components: [
            SetComponent(type: .warmup, distance: 400, strokeStyle: .mixed, instructions: "400 warmup mixed"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .butterfly, instructions: "8x50 butterfly on 50s"),
            SetComponent(type: .swim, distance: 100, strokeStyle: .butterfly, instructions: "4x25 fly sprints on 30s"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 cool down")
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.intermediate, description: "High-intensity butterfly sprints."),
        SwimSet(title: "IM Pro Series", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "400 IM as 100 of each"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "4x100 IM on 1:50"),
            SetComponent(type: .kick, distance: 200, strokeStyle: .kickboard, instructions: "200 IM kick"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "8x50 IM order sprint each"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy")
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.advanced, description: "Comprehensive IM workout for all strokes."),
        SwimSet(title: "Marathon Freestyle", components: [
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "1000 straight swim"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "5x200 on 2:45"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:15"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cooldown")
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.advanced, description: "Long-distance freestyle set for endurance."),
        SwimSet(title: "Beginner Breaststroke Basics", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 400, strokeStyle: .breaststroke, instructions: "8x50 drill on 1:10"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .breaststroke, instructions: "4x100 swim on 2:00"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy cooldown")
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.beginner, description: "Easy-going set for breaststroke beginners."),
        SwimSet(title: "Speedy Freestyle Flicks", components: [
            SetComponent(type: .warmup, distance: 50, strokeStyle: .freestyle, instructions: "50 warmup"),
            SetComponent(type: .swim, distance: 250, strokeStyle: .freestyle, instructions: "10x25 sprint on 20 seconds"),
            SetComponent(type: .cooldown, distance: 50, strokeStyle: .mixed, instructions: "50 cooldown")
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.intermediate, description: "Short distance, high-intensity freestyle sprints."),
        SwimSet(title: "Medley Mastery", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "400 IM"),
            SetComponent(type: .swim, distance: 800, strokeStyle: .mixed, instructions: "8x100 IM on 1:40"),
            SetComponent(type: .kick, distance: 400, strokeStyle: .kickboard, instructions: "8x50 IM kick on 1:00"),
            SetComponent(type: .cooldown, distance: 400, strokeStyle: .freestyle, instructions: "400 freestyle cool down")
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.advanced, description: "Advanced set for mastering the individual medley."),
        SwimSet(title: "Freestyle Fundamentals", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 200, strokeStyle: .freestyle, instructions: "8x25 freestyle technique focus"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 cool down")
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.beginner, description: "Basic freestyle techniques and endurance."),
        SwimSet(title: "Backstroke Basics", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 150, strokeStyle: .backstroke, instructions: "6x25 backstroke drills"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 cool down")
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.beginner, description: "Fundamentals of backstroke, focusing on form."),
        SwimSet(title: "Intermediate Butterfly", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 mixed warmup"),
            SetComponent(type: .swim, distance: 500, strokeStyle: .butterfly, instructions: "5x100 butterfly on 2:00"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy cool down")
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.intermediate, description: "Building strength and technique in butterfly."),
        SwimSet(title: "Stroke Variety Pack", components: [
            SetComponent(type: .warmup, distance: 100, strokeStyle: .mixed, instructions: "100 IM warmup"),
            SetComponent(type: .swim, distance: 200, strokeStyle: .mixed, instructions: "4x50 each stroke focus"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 easy cooldown")
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.beginner, description: "Introduction to all strokes, focusing on transitions."),
        SwimSet(title: "Breaststroke Endurance", components: [
            SetComponent(type: .warmup, distance: 500, strokeStyle: .mixed, instructions: "500 warmup"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .breaststroke, instructions: "10x100 on 1:50"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down")
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.advanced, description: "Long distance, endurance training for breaststroke.")
    ]

    // init
    override init()
    {

        self.healthStore = HKHealthStore()
        self.permission = true
        super.init()
        loadFromJSONOrDefault()

    }

    // MARK: Loading from HealthStore
    // determines whether to load from JSON or if needed to use healthstore imports
    func loadFromJSONOrDefault() 
    {
        let fileManager = FileManager.default
        let url = getDocumentsDirectory().appendingPathComponent("store.json")
        
        // check if the JSON file exists
        if fileManager.fileExists(atPath: url.path)
        {
            loadFromJSON()  // attempt to load from JSON
            
            // check if the swims are empty after attempting to load
            if self.swims.isEmpty
            {
                print("No swims data found in JSON, loading from HealthKit.")
                loadAllSwimmingWorkouts()
            } 
            else
            {
                print("Loaded swims from JSON successfully.")
                calcFields()
            }
        } 
        else
        {
            // if JSON file doesn't exist, proceed with loading from HealthKit
            print("No JSON file found, loading from HealthKit.")
            loadAllSwimmingWorkouts()
        }
    }
    
    // load from healthStore
    func loadAllSwimmingWorkouts()
    {
        self.swims.removeAll()
        
        // creating query
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .swimming)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor])
        { [weak self] (query, samples, error) in
            guard let self = self, let workouts = samples as? [HKWorkout], error == nil else
            {
                print("Failed to fetch workouts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // perform updates on main thread - for all workouts
            DispatchQueue.main.async
            {
                for workout in workouts 
                {
                    // making the swim struct
                    let id = UUID()
                    let date = workout.startDate
                    let duration = workout.duration
                    let totalDistance: Double = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
                    let totalEnergyBurned: Double = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
                    var poolLength: Double?
                    var laps = [Lap]()

                    // getting laps in the workout
                    if let events = workout.workoutEvents
                    {
                        for event in events where event.type == .lap
                        {
                            if let metadata = event.metadata 
                            {
                                let startDate = event.dateInterval.start
                                let endDate = event.dateInterval.end
                                let lap = Lap(startDate: startDate, endDate: endDate, metadata: metadata)
                                laps.append(lap)
                            }
                        }
                    }

                    // getting pool length
                    if let metadata = workout.metadata, let metaLap = metadata[HKMetadataKeyLapLength] as? HKQuantity
                    {
                        poolLength = metaLap.doubleValue(for: HKUnit.meter())
                    }

                    // append swim
                    let swim = Swim(id: id, startDate: date, endDate: date.addingTimeInterval(duration), totalDistance: totalDistance, totalEnergyBurned: totalEnergyBurned, poolLength: poolLength, laps: laps)
                    self.swims.append(swim)
                }
                // once done with loops, calc fields and update storage
                self.calcFields()
                self.updateStore()
            }

        }
        healthStore.execute(query)
    }
    
    // calcs user totals
    func calcFields()
    {
        var tDis = 0.0
        var tCals = 0.0
        var count = 0

        for swim in self.swims
        {
            tDis += swim.totalDistance ?? 0
            tCals += swim.totalEnergyBurned ?? 0
            count += 1
        }
        
        totalDistance = tDis
        averageDistance = count > 0 ? tDis / Double(count) : 0
        totalCalories = tCals
        averageCalories = count > 0 ? tCals / Double(count) : 0
    }
    
    // updateStore for JSON
    func updateStore()
    {
        store.swims = swims
        store.preferredStroke = preferredStroke
        store.preferredUnit = preferredUnit
        store.userName = userName
        saveToJSON()
    }
    
    // MARK: Persistence funcs
    
    // save
    func saveToJSON()
    {
        let url = getDocumentsDirectory().appendingPathComponent("store.json")
        do 
        {
            let encoder = JSONEncoder()
            let data = try encoder.encode(store)
            // move data writing to background thread
            DispatchQueue.global(qos: .background).async
            {
                do
                {
                    try data.write(to: url, options: [.atomicWrite, .completeFileProtection])
                    DispatchQueue.main.async 
                    {
                        print("Saved to \(url)")
                    }
                } 
                catch
                {
                    DispatchQueue.main.async 
                    {
                        print("Failed to save: \(error)")
                    }
                }
            }
        } 
        catch
        {
            print("Failed to save: \(error)")
        }
    }
    
    // load
    func loadFromJSON()
    {
        let url = getDocumentsDirectory().appendingPathComponent("store.json")
        do 
        {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            store = try decoder.decode(Store.self, from: data)
            updateLocalStoreValues()
        }
        catch
        {
            print("Failed to load JSON from \(url): \(error)")
        }
    }

    // update local vals
    private func updateLocalStoreValues() 
    {
        self.swims = store.swims
        self.userName = store.userName
        self.preferredStroke = store.preferredStroke
        self.preferredUnit = store.preferredUnit
        calcFields()
    }
    
    // gets document directory for the URL
    func getDocumentsDirectory() -> URL
    {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    
}

// struct to store for persistence
struct Store: Codable
{
    var userName: String
    var preferredStroke: SwimStroke
    var preferredUnit: MeasureUnit
    var swims: [Swim]
}


// extended for use in graphs
extension Calendar 
{
    func startOfMonth(for date: Date) -> Date 
    {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
}

// distance formatter
extension Manager 
{
    func formatDistance(_ meters: Double) -> String
    {
        if preferredUnit == MeasureUnit.yards
        {
            // converts into yards
            let yards = meters * 1.09361
            return String(format: "%.1f yd", yards)
        } 
        // else return string format of meters
        else
        {
            return String(format: "%.1f m", meters)
        }
    }
}

// aggregate data by month
extension Manager
{
    // combine data for swift charts
    func aggregateDataByMonth(swims: [Swim]) -> [Swim]
    {
        let grouped = Dictionary(grouping: swims)
        { (swim) in
            Calendar.current.startOfMonth(for: swim.date)
        }
        return grouped.map
        { (month, swims) in
            let duration = swims.reduce(0, { total, swim in total + swim.duration })
            let totalDistance = swims.compactMap({ $0.totalDistance }).reduce(0, +)
            let totalEnergyBurned = swims.compactMap({ $0.totalEnergyBurned }).reduce(0, +)
            // Use month as startDate, and month.addingTimeInterval(duration) as endDate.
            return Swim(
                id: UUID(),
                startDate: month,
                endDate: month.addingTimeInterval(duration),
                totalDistance: totalDistance,
                totalEnergyBurned: totalEnergyBurned,
                poolLength: nil,
                locationType: .unknown,
                laps: []
            )
        }.sorted(by: { (a, b) in a.date < b.date })
    }
}

// MARK: - Workout Analysis
extension Manager 
{
    func groupLapsByRestPeriods(_ laps: [Lap], poolLength: Double) -> [WorkoutSet]
    {
        guard !laps.isEmpty else { return [] }
        
        // Step 1: Create consecutive swims based on rest periods
        var consecutiveSwims: [ConsecutiveSwim] = []
        var currentSwimLaps: [Lap] = [laps[0]]
        var currentStartLap = 1
        
        for i in 1..<laps.count {
            let previousLap = laps[i-1]
            let currentLap = laps[i]
            let restPeriod = previousLap.restPeriodTo(currentLap)
            
            // If rest period is short and same stroke, add to current swim
            if restPeriod <= ConsecutiveSwim.consecutiveThreshold &&
               currentLap.stroke == previousLap.stroke {
                currentSwimLaps.append(currentLap)
            } else {
                // Finish current swim and start new one
                consecutiveSwims.append(ConsecutiveSwim(
                    laps: currentSwimLaps,
                    startLapNumber: currentStartLap
                ))
                
                currentSwimLaps = [currentLap]
                currentStartLap = i + 1
            }
        }
        
        // Don't forget the last swim
        consecutiveSwims.append(ConsecutiveSwim(
            laps: currentSwimLaps,
            startLapNumber: currentStartLap
        ))
        
        // Step 2: Group similar consecutive swims into sets
        var workoutSets: [WorkoutSet] = []
        var currentSetSwims: [ConsecutiveSwim] = []
        var setNumber = 1
        
        for i in 0..<consecutiveSwims.count {
            let currentSwim = consecutiveSwims[i]
            
            if currentSetSwims.isEmpty {
                // Start new set
                currentSetSwims = [currentSwim]
            } else {
                let previousSwim = currentSetSwims.last!
                
                // Calculate rest between the end of previous swim and start of current swim
                let restBetweenSwims: TimeInterval
                if let lastLapOfPrevious = previousSwim.laps.last,
                   let firstLapOfCurrent = currentSwim.laps.first {
                    restBetweenSwims = firstLapOfCurrent.startDate.timeIntervalSince(lastLapOfPrevious.endDate)
                } else {
                    restBetweenSwims = 0
                }
                
                // Check if swims are similar and rest is reasonable
                let sameStroke = currentSwim.effectiveStrokeStyle == previousSwim.effectiveStrokeStyle
                let similarLapCount = abs(currentSwim.laps.count - previousSwim.laps.count) <= 1
                let reasonableRest = restBetweenSwims <= ConsecutiveSwim.setThreshold
                
                if sameStroke && similarLapCount && reasonableRest {
                    currentSetSwims.append(currentSwim)
                } else {
                    // Finish current set and start new one
                    workoutSets.append(WorkoutSet(
                        consecutiveSwims: currentSetSwims,
                        setNumber: setNumber
                    ))
                    
                    currentSetSwims = [currentSwim]
                    setNumber += 1
                }
            }
        }
        
        // Don't forget the last set
        if !currentSetSwims.isEmpty {
            workoutSets.append(WorkoutSet(
                consecutiveSwims: currentSetSwims,
                setNumber: setNumber
            ))
        }
        
        return workoutSets
    }
}

// MARK: - Statistics and Calculations
extension Manager 
{
    func formatTotalDistance(from filteredWorkouts: [Swim]) -> String
    {
        let total = filteredWorkouts.compactMap { $0.totalDistance }.reduce(0, +)
        return formatDistance(total)
    }
    
    func formatTotalTime(from filteredWorkouts: [Swim]) -> String
    {
        let totalSeconds = filteredWorkouts.reduce(0)
        { total, swim in total + swim.duration }
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60
        return "\(hours)h \(minutes)m"
    }
    
    func formatAverageDistance(from filteredWorkouts: [Swim]) -> String
    {
        guard !filteredWorkouts.isEmpty else { return formatDistance(0) }
        let average = filteredWorkouts.compactMap
        { $0.totalDistance }.reduce(0, +) / Double(filteredWorkouts.count)
        return formatDistance(average)
    }
    
    func calculateAveragePace(for swim: Swim) -> String
    {
        guard let totalDistance = swim.totalDistance, totalDistance > 0 else
        { return "N/A" }
        let pace = swim.duration / (totalDistance / 100.0)
        let minutes = Int(pace) / 60
        let seconds = Int(pace) % 60
        return String(format: "%d:%02d/100m", minutes, seconds)
    }
    
    func averageSwolfScore(for swim: Swim) -> String
    {
        let validLaps = swim.laps.filter { $0.swolfScore != nil }
        guard !validLaps.isEmpty else { return "N/A" }
        let average = validLaps.compactMap { $0.swolfScore }.reduce(0, +) / Double(validLaps.count)
        return "\(average)"
    }
    
    func getCurrentWeekDistance() -> Double
    {
        let calendar = Calendar.current
        let now = Date()
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start else { return 0.0 }
        
        return swims.filter { swim in swim.date >= weekStart }
            .compactMap { $0.totalDistance }
            .reduce(0, +)
    }
    
    func getCurrentWeekWorkouts() -> Int
    {
        let calendar = Calendar.current
        let now = Date()
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start else { return 0 }
        
        return swims.filter { swim in swim.date >= weekStart }.count
    }
    
    func goalProgress() -> Double
    {
        let currentDistance = getCurrentWeekDistance()
        return min(currentDistance / weeklyGoalDistance, 1.0)
    }
    
    func goalProgressText() -> String
    {
        let currentDistance = getCurrentWeekDistance()
        let currentWorkouts = getCurrentWeekWorkouts()
        let distanceProgress = (currentDistance / weeklyGoalDistance) * 100
        let workoutProgress = (Double(currentWorkouts) / Double(weeklyGoalWorkouts)) * 100
        
        if distanceProgress >= 100 && workoutProgress >= 100 {
            return "🎉 Goals achieved!"
        } else if distanceProgress >= 100 {
            return "Distance goal reached! \(weeklyGoalWorkouts - currentWorkouts) workouts to go"
        } else if workoutProgress >= 100 {
            return "Workout goal reached! \(Int(weeklyGoalDistance - currentDistance))m to go"
        } else {
            return "\(Int(distanceProgress))% distance, \(Int(workoutProgress))% workouts"
        }
    }
}

// MARK: - Data Filtering and Search
extension Manager 
{
    func filteredWorkouts(searchText: String, dateFilter: String) -> [Swim]
    {
        var filtered = swims
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { swim in
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let dateString = dateFormatter.string(from: swim.date)
                return dateString.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply date filter
        let calendar = Calendar.current
        let now = Date()
        
        switch dateFilter {
        case "This Week":
            if let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start {
                filtered = filtered.filter { $0.date >= weekStart }
            }
        case "This Month":
            if let monthStart = calendar.dateInterval(of: .month, for: now)?.start {
                filtered = filtered.filter { $0.date >= monthStart }
            }
        case "Last 3 Months":
            if let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now) {
                filtered = filtered.filter { $0.date >= threeMonthsAgo }
            }
        default:
            break
        }
        
        return filtered.sorted { a, b in a.date > b.date }
    }
}

// MARK: - Weekly Statistics and Trends
extension Manager 
{
    func weeklyStats() -> (workouts: Int, distance: Double, time: TimeInterval)
    {
        let calendar = Calendar.current
        let now = Date()
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start else {
            return (0, 0.0, 0)
        }
        
        let weeklySwims = swims.filter { $0.date >= weekStart }
        let workouts = weeklySwims.count
        let distance = weeklySwims.compactMap { $0.totalDistance }.reduce(0, +)
        let time = weeklySwims.reduce(0) { $0 + $1.duration }
        
        return (workouts, distance, time)
    }
    
    func weeklyWorkoutTrend() -> String
    {
        let calendar = Calendar.current
        let now = Date()
        
        guard let thisWeekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start,
              let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) else {
            return "stable"
        }
        
        let thisWeekWorkouts = swims.filter { $0.date >= thisWeekStart }.count
        let lastWeekWorkouts = swims.filter { $0.date >= lastWeekStart && $0.date < thisWeekStart }.count
        
        if thisWeekWorkouts > lastWeekWorkouts {
            return "up"
        } else if thisWeekWorkouts < lastWeekWorkouts {
            return "down"
        } else {
            return "stable"
        }
    }
    
    func weeklyDistanceTrend() -> String
    {
        let calendar = Calendar.current
        let now = Date()
        
        guard let thisWeekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start,
              let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) else {
            return "stable"
        }
        
        let thisWeekDistance = swims.filter { $0.date >= thisWeekStart }.compactMap { $0.totalDistance }.reduce(0, +)
        let lastWeekDistance = swims.filter { $0.date >= lastWeekStart && $0.date < thisWeekStart }.compactMap { $0.totalDistance }.reduce(0, +)
        
        if thisWeekDistance > lastWeekDistance {
            return "up"
        } else if thisWeekDistance < lastWeekDistance {
            return "down"
        } else {
            return "stable"
        }
    }
    
    func weeklyTimeTrend() -> String
    {
        let calendar = Calendar.current
        let now = Date()
        
        guard let thisWeekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start,
              let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) else {
            return "stable"
        }
        
        let thisWeekTime = swims.filter { $0.date >= thisWeekStart }.reduce(0) { $0 + $1.duration }
        let lastWeekTime = swims.filter { $0.date >= lastWeekStart && $0.date < thisWeekStart }.reduce(0) { $0 + $1.duration }
        
        if thisWeekTime > lastWeekTime {
            return "up"
        } else if thisWeekTime < lastWeekTime {
            return "down"
        } else {
            return "stable"
        }
    }
}

// MARK: - Chart Data Aggregation
extension Manager 
{
    func aggregateSwimsByWeek() -> [Swim]
    {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: swims) { swim in
            calendar.dateInterval(of: .weekOfYear, for: swim.date)?.start ?? swim.date
        }
        
        return grouped.map { (week, swims) in
            let duration = swims.reduce(0, { total, swim in total + swim.duration })
            let totalDistance = swims.compactMap({ $0.totalDistance }).reduce(0, +)
            let totalEnergyBurned = swims.compactMap({ $0.totalEnergyBurned }).reduce(0, +)
            
            return Swim(
                id: UUID(),
                startDate: week,
                endDate: week.addingTimeInterval(duration),
                totalDistance: totalDistance,
                totalEnergyBurned: totalEnergyBurned,
                poolLength: nil,
                locationType: .unknown,
                laps: []
            )
        }.sorted(by: { (a, b) in a.date < b.date })
    }
    
    func aggregateSwimsByQuarter() -> [Swim]
    {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: swims) { swim in
            let components = calendar.dateComponents([.year, .quarter], from: swim.date)
            return calendar.date(from: components) ?? swim.date
        }
        
        return grouped.map { (quarter, swims) in
            let duration = swims.reduce(0, { total, swim in total + swim.duration })
            let totalDistance = swims.compactMap({ $0.totalDistance }).reduce(0, +)
            let totalEnergyBurned = swims.compactMap({ $0.totalEnergyBurned }).reduce(0, +)
            
            return Swim(
                id: UUID(),
                startDate: quarter,
                endDate: quarter.addingTimeInterval(duration),
                totalDistance: totalDistance,
                totalEnergyBurned: totalEnergyBurned,
                poolLength: nil,
                locationType: .unknown,
                laps: []
            )
        }.sorted(by: { (a, b) in a.date < b.date })
    }
    
    func formatAxisLabel(for date: Date, range: String) -> String
    {
        let formatter = DateFormatter()
        
        switch range {
        case "Week":
            formatter.dateFormat = "M/d"
        case "Month":
            formatter.dateFormat = "M/d"
        case "Quarter":
            formatter.dateFormat = "MMM"
        case "Year":
            formatter.dateFormat = "MMM"
        default:
            formatter.dateFormat = "M/d"
        }
        
        return formatter.string(from: date)
    }
    
    func chartDataFiltered(by range: String) -> [Swim]
    {
        let calendar = Calendar.current
        let now = Date()
        var filtered: [Swim]
        
        switch range {
        case "Week":
            if let weekStart = calendar.date(byAdding: .day, value: -7, to: now) {
                filtered = swims.filter { $0.date >= weekStart }
            } else {
                filtered = swims
            }
            return aggregateSwimsByWeek().filter { swim in filtered.contains { filteredSwim in filteredSwim.date >= swim.date } }
            
        case "Month":
            if let monthStart = calendar.date(byAdding: .month, value: -1, to: now) {
                filtered = swims.filter { $0.date >= monthStart }
            } else {
                filtered = swims
            }
            return aggregateSwimsByWeek().filter { swim in filtered.contains { filteredSwim in filteredSwim.date >= swim.date } }
            
        case "Quarter":
            if let quarterStart = calendar.date(byAdding: .month, value: -3, to: now) {
                filtered = swims.filter { $0.date >= quarterStart }
            } else {
                filtered = swims
            }
            return aggregateSwimsByWeek().filter { swim in filtered.contains { filteredSwim in filteredSwim.date >= swim.date } }
            
        case "Year":
            if let yearStart = calendar.date(byAdding: .year, value: -1, to: now) {
                filtered = swims.filter { $0.date >= yearStart }
            } else {
                filtered = swims
            }
            return aggregateSwimsByQuarter().filter { swim in filtered.contains { filteredSwim in filteredSwim.date >= swim.date } }
            
        default:
            return aggregateDataByMonth(swims: swims)
        }
    }
}

// MARK: - Storage and Data Management
extension Manager 
{
    func getLocalStorageInfo() -> String
    {
        let documentsPath = getDocumentsDirectory()
        
        do {
            let fileManager = FileManager.default
            let files = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: [.fileSizeKey])
            
            var totalSize: Int64 = 0
            for file in files {
                if let fileSize = try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                    totalSize += Int64(fileSize)
                }
            }
            
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useKB, .useMB]
            formatter.countStyle = .file
            
            return formatter.string(fromByteCount: totalSize)
        } catch {
            return "Unable to calculate"
        }
    }
    
    func calculateStorageUsed() -> String
    {
        return getLocalStorageInfo()
    }
    
    func deleteAllData()
    {
        self.swims.removeAll()
        self.totalDistance = 0.0
        self.averageDistance = 0.0
        self.totalCalories = 0.0
        self.averageCalories = 0.0
        self.favoriteSetIds.removeAll()
        
        updateStore()
        
        // Also clear the JSON file
        let url = getDocumentsDirectory().appendingPathComponent("store.json")
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: - Set Filtering

extension Manager 
{
    func isQuickFilterSelected(_ filter: String) -> Bool
    {
        switch filter {
        case "Favorites":
            return activeFilters.showFavorites
        case "Beginner":
            return activeFilters.difficulty == SwimSet.Difficulty.beginner
        case "Intermediate":
            return activeFilters.difficulty == SwimSet.Difficulty.intermediate
        case "Advanced":
            return activeFilters.difficulty == SwimSet.Difficulty.advanced
        case "Freestyle":
            return activeFilters.stroke == SwimStroke.freestyle
        case "Backstroke":
            return activeFilters.stroke == SwimStroke.backstroke
        case "Breaststroke":
            return activeFilters.stroke == SwimStroke.breaststroke
        case "Butterfly":
            return activeFilters.stroke == SwimStroke.butterfly
        default:
            return false
        }
    }
    
    func applyQuickFilter(_ filter: String)
    {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            switch filter {
            case "Favorites":
                activeFilters.showFavorites.toggle()
            case "Beginner":
                activeFilters.difficulty = activeFilters.difficulty == SwimSet.Difficulty.beginner ? nil : SwimSet.Difficulty.beginner
            case "Intermediate":
                activeFilters.difficulty = activeFilters.difficulty == SwimSet.Difficulty.intermediate ? nil : SwimSet.Difficulty.intermediate
            case "Advanced":
                activeFilters.difficulty = activeFilters.difficulty == SwimSet.Difficulty.advanced ? nil : SwimSet.Difficulty.advanced
            case "Freestyle":
                activeFilters.stroke = activeFilters.stroke == SwimStroke.freestyle ? nil : SwimStroke.freestyle
            case "Backstroke":
                activeFilters.stroke = activeFilters.stroke == SwimStroke.backstroke ? nil : SwimStroke.backstroke
            case "Breaststroke":
                activeFilters.stroke = activeFilters.stroke == SwimStroke.breaststroke ? nil : SwimStroke.breaststroke
            case "Butterfly":
                activeFilters.stroke = activeFilters.stroke == SwimStroke.butterfly ? nil : SwimStroke.butterfly
            default:
                break
            }
        }
    }
    
    func performSearch(with searchText: String)
    {
        activeFilters.searchText = searchText
    }
}

// MARK: - Helper Functions for Views
extension Manager 
{
    func formatDuration(_ duration: TimeInterval) -> String
    {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    func getStrokes(from swim: Swim) -> String?
    {
        let uniqueStrokes = Set(swim.laps.compactMap { $0.stroke?.description })
        if uniqueStrokes.isEmpty {
            return nil
        }
        return uniqueStrokes.joined(separator: ", ")
    }
    
    func filteredWorkouts(for timeFilter: String) -> [Swim]
    {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let dateLimit: Date? = {
            switch timeFilter {
            case "30 Days":
                return calendar.date(byAdding: .day, value: -30, to: currentDate)
            case "90 Days":
                return calendar.date(byAdding: .day, value: -90, to: currentDate)
            case "6 Months":
                return calendar.date(byAdding: .month, value: -6, to: currentDate)
            case "Year":
                return calendar.date(byAdding: .year, value: -1, to: currentDate)
            case "All Time":
                return nil
            default:
                return nil
            }
        }()
        
        if let dateLimit = dateLimit {
            return swims.filter { swim in swim.date >= dateLimit }
                .sorted(by: { a, b in a.date > b.date })
        } else {
            return swims.sorted(by: { a, b in a.date > b.date })
        }
    }
    
    func displayedWorkouts(from filtered: [Swim], searchText: String) -> [Swim]
    {
        guard !searchText.isEmpty else { return filtered }
        
        return filtered.filter { swim in
            let dateString = swim.date.formatted(.dateTime.weekday().month().day())
            let durationString = formatDuration(swim.duration)
            let strokesString = getStrokes(from: swim) ?? ""
            
            return dateString.localizedCaseInsensitiveContains(searchText) ||
                   durationString.localizedCaseInsensitiveContains(searchText) ||
                   strokesString.localizedCaseInsensitiveContains(searchText)
        }
    }
}

