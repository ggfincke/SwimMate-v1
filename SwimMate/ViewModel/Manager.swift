// SwimMate/ViewModel/Manager.swift

// the iOS manager/view model
import Foundation
import HealthKit

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var displayName: String {
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
        ], measureUnit: .meters, difficulty: .intermediate, description: "A challenging endurance set to boost stamina."),
        SwimSet(title: "Technique Tuner", components: [
            SetComponent(type: .swim, distance: 200, strokeStyle: .breaststroke, instructions: "200 swim, 200 pull, 200 kick"),
            SetComponent(type: .drill, distance: 500, strokeStyle: .breaststroke, instructions: "10x50 on 50s, odds drill, evens swim"),
            SetComponent(type: .pull, distance: 400, strokeStyle: .breaststroke, instructions: "4x100 pull with paddles on 1:40"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy")
        ], measureUnit: .yards, difficulty: .advanced, description: "Focus on technique and power."),
        SwimSet(title: "Backstroke Blast", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .backstroke, instructions: "4x100 backstroke on 2:00"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .backstroke, instructions: "8x50 back fast on 1:00"),
            SetComponent(type: .swim, distance: 100, strokeStyle: .backstroke, instructions: "4x25 sprint on 30s"),
            SetComponent(type: .cooldown, distance: 300, strokeStyle: .mixed, instructions: "300 easy")
        ], measureUnit: .meters, difficulty: .beginner, description: "Speed work for improving backstroke performance."),
        SwimSet(title: "Butterfly Sprint Series", components: [
            SetComponent(type: .warmup, distance: 400, strokeStyle: .mixed, instructions: "400 warmup mixed"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .butterfly, instructions: "8x50 butterfly on 50s"),
            SetComponent(type: .swim, distance: 100, strokeStyle: .butterfly, instructions: "4x25 fly sprints on 30s"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 cool down")
        ], measureUnit: .yards, difficulty: .intermediate, description: "High-intensity butterfly sprints."),
        SwimSet(title: "IM Pro Series", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "400 IM as 100 of each"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "4x100 IM on 1:50"),
            SetComponent(type: .kick, distance: 200, strokeStyle: .kickboard, instructions: "200 IM kick"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "8x50 IM order sprint each"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy")
        ], measureUnit: .meters, difficulty: .advanced, description: "Comprehensive IM workout for all strokes."),
        SwimSet(title: "Marathon Freestyle", components: [
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "1000 straight swim"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "5x200 on 2:45"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:15"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cooldown")
        ], measureUnit: .yards, difficulty: .advanced, description: "Long-distance freestyle set for endurance."),
        SwimSet(title: "Beginner Breaststroke Basics", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 400, strokeStyle: .breaststroke, instructions: "8x50 drill on 1:10"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .breaststroke, instructions: "4x100 swim on 2:00"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy cooldown")
        ], measureUnit: .meters, difficulty: .beginner, description: "Easy-going set for breaststroke beginners."),
        SwimSet(title: "Speedy Freestyle Flicks", components: [
            SetComponent(type: .warmup, distance: 50, strokeStyle: .freestyle, instructions: "50 warmup"),
            SetComponent(type: .swim, distance: 250, strokeStyle: .freestyle, instructions: "10x25 sprint on 20 seconds"),
            SetComponent(type: .cooldown, distance: 50, strokeStyle: .mixed, instructions: "50 cooldown")
        ], measureUnit: .yards, difficulty: .intermediate, description: "Short distance, high-intensity freestyle sprints."),
        SwimSet(title: "Medley Mastery", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "400 IM"),
            SetComponent(type: .swim, distance: 800, strokeStyle: .mixed, instructions: "8x100 IM on 1:40"),
            SetComponent(type: .kick, distance: 400, strokeStyle: .kickboard, instructions: "8x50 IM kick on 1:00"),
            SetComponent(type: .cooldown, distance: 400, strokeStyle: .freestyle, instructions: "400 freestyle cool down")
        ], measureUnit: .meters, difficulty: .advanced, description: "Advanced set for mastering the individual medley."),
        SwimSet(title: "Freestyle Fundamentals", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 200, strokeStyle: .freestyle, instructions: "8x25 freestyle technique focus"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 cool down")
        ], measureUnit: .meters, difficulty: .beginner, description: "Basic freestyle techniques and endurance."),
        SwimSet(title: "Backstroke Basics", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 150, strokeStyle: .backstroke, instructions: "6x25 backstroke drills"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 cool down")
        ], measureUnit: .yards, difficulty: .beginner, description: "Fundamentals of backstroke, focusing on form."),
        SwimSet(title: "Intermediate Butterfly", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 mixed warmup"),
            SetComponent(type: .swim, distance: 500, strokeStyle: .butterfly, instructions: "5x100 butterfly on 2:00"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy cool down")
        ], measureUnit: .yards, difficulty: .intermediate, description: "Building strength and technique in butterfly."),
        SwimSet(title: "Stroke Variety Pack", components: [
            SetComponent(type: .warmup, distance: 100, strokeStyle: .mixed, instructions: "100 IM warmup"),
            SetComponent(type: .swim, distance: 200, strokeStyle: .mixed, instructions: "4x50 each stroke focus"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 easy cooldown")
        ], measureUnit: .yards, difficulty: .beginner, description: "Introduction to all strokes, focusing on transitions."),
        SwimSet(title: "Breaststroke Endurance", components: [
            SetComponent(type: .warmup, distance: 500, strokeStyle: .mixed, instructions: "500 warmup"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .breaststroke, instructions: "10x100 on 1:50"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down")
        ], measureUnit: .meters, difficulty: .advanced, description: "Long distance, endurance training for breaststroke.")
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
            tDis += swim.totalDistance!
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
    func getDocumentsDirectory() -> URL {
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
        { swim in
            Calendar.current.startOfMonth(for: swim.date)
        }
        return grouped.map
        { (month, swims) in
            let duration = swims.reduce(0, { $0 + $1.duration })
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
        }.sorted(by: { $0.date < $1.date })
    }
}

