// SwimMate/ViewModel/Manager.swift

// the iOS manager/view model
import Foundation
import HealthKit
import os
import SwiftUI

enum AppTheme: String, CaseIterable
{
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var displayName: String
    {
        return rawValue
    }
}

class Manager: NSObject, ObservableObject
{
    // MARK: vars / init

    // healthkit vars
    var permission: Bool
    let healthStore: HKHealthStore
    var currentWorkoutSession: HKWorkoutSession?

    // user preferences
    @Published var userName: String = "User"
    @Published var preferredStroke: SwimStroke? = .freestyle
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
    @Published var store: Store = .init(userName: "Default User", preferredStroke: .freestyle, preferredUnit: .meters, swims: [])

    // user totals (calculated values)
    @Published var totalDistance: Double = 0.0
    @Published var averageDistance: Double = 0.0
    @Published var totalCalories: Double = 0.0
    @Published var averageCalories: Double = 0.0

    // TODO: replace with database integration at some point
    // very long list of sample sets
    let sampleSets: [SwimSet] = [
        SwimSet(title: "Endurance Challenge", components: [
            SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30, descend 1-5, 6-10"),
            SetComponent(type: .kick, distance: 500, strokeStyle: .kickboard, instructions: "10x50 kick on 1:00"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down easy"),
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.intermediate, description: "A challenging endurance set to boost stamina.", primaryStroke: [.freestyle]),
        SwimSet(title: "Technique Tuner", components: [
            SetComponent(type: .swim, distance: 200, strokeStyle: .breaststroke, instructions: "200 swim, 200 pull, 200 kick"),
            SetComponent(type: .drill, distance: 500, strokeStyle: .breaststroke, instructions: "10x50 on 50s, odds drill, evens swim"),
            SetComponent(type: .pull, distance: 400, strokeStyle: .breaststroke, instructions: "4x100 pull with paddles on 1:40"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy"),
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.advanced, description: "Focus on technique and power.", primaryStroke: [.breaststroke]),
        SwimSet(title: "Backstroke Blast", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .backstroke, instructions: "4x100 backstroke on 2:00"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .backstroke, instructions: "8x50 back fast on 1:00"),
            SetComponent(type: .swim, distance: 100, strokeStyle: .backstroke, instructions: "4x25 sprint on 30s"),
            SetComponent(type: .cooldown, distance: 300, strokeStyle: .mixed, instructions: "300 easy"),
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.beginner, description: "Speed work for improving backstroke performance.", primaryStroke: [.backstroke]),
        SwimSet(title: "Butterfly Sprint Series", components: [
            SetComponent(type: .warmup, distance: 400, strokeStyle: .mixed, instructions: "400 warmup mixed"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .butterfly, instructions: "8x50 butterfly on 50s"),
            SetComponent(type: .swim, distance: 100, strokeStyle: .butterfly, instructions: "4x25 fly sprints on 30s"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 cool down"),
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.intermediate, description: "High-intensity butterfly sprints.", primaryStroke: [.butterfly]),
        SwimSet(title: "IM Pro Series", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "400 IM as 100 of each"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "4x100 IM on 1:50"),
            SetComponent(type: .kick, distance: 200, strokeStyle: .kickboard, instructions: "200 IM kick"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "8x50 IM order sprint each"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy"),
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.advanced, description: "Comprehensive IM workout for all strokes.", primaryStroke: [.butterfly, .backstroke, .breaststroke, .freestyle]),
        SwimSet(title: "Marathon Freestyle", components: [
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "1000 straight swim"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "5x200 on 2:45"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:15"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cooldown"),
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.advanced, description: "Long-distance freestyle set for endurance.", primaryStroke: [.freestyle]),
        SwimSet(title: "Beginner Breaststroke Basics", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 400, strokeStyle: .breaststroke, instructions: "8x50 drill on 1:10"),
            SetComponent(type: .swim, distance: 400, strokeStyle: .breaststroke, instructions: "4x100 swim on 2:00"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy cooldown"),
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.beginner, description: "Easy-going set for breaststroke beginners.", primaryStroke: [.breaststroke]),
        SwimSet(title: "Speedy Freestyle Flicks", components: [
            SetComponent(type: .warmup, distance: 50, strokeStyle: .freestyle, instructions: "50 warmup"),
            SetComponent(type: .swim, distance: 250, strokeStyle: .freestyle, instructions: "10x25 sprint on 20 seconds"),
            SetComponent(type: .cooldown, distance: 50, strokeStyle: .mixed, instructions: "50 cooldown"),
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.intermediate, description: "Short distance, high-intensity freestyle sprints.", primaryStroke: [.freestyle]),
        SwimSet(title: "Medley Mastery", components: [
            SetComponent(type: .swim, distance: 400, strokeStyle: .mixed, instructions: "400 IM"),
            SetComponent(type: .swim, distance: 800, strokeStyle: .mixed, instructions: "8x100 IM on 1:40"),
            SetComponent(type: .kick, distance: 400, strokeStyle: .kickboard, instructions: "8x50 IM kick on 1:00"),
            SetComponent(type: .cooldown, distance: 400, strokeStyle: .freestyle, instructions: "400 freestyle cool down"),
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.advanced, description: "Advanced set for mastering the individual medley.", primaryStroke: [.butterfly, .backstroke, .breaststroke, .freestyle]),
        SwimSet(title: "Freestyle Fundamentals", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 200, strokeStyle: .freestyle, instructions: "8x25 freestyle technique focus"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 cool down"),
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.beginner, description: "Basic freestyle techniques and endurance.", primaryStroke: [.freestyle]),
        SwimSet(title: "Backstroke Basics", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 easy warmup"),
            SetComponent(type: .drill, distance: 150, strokeStyle: .backstroke, instructions: "6x25 backstroke drills"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 cool down"),
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.beginner, description: "Fundamentals of backstroke, focusing on form.", primaryStroke: [.backstroke]),
        SwimSet(title: "Intermediate Butterfly", components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .mixed, instructions: "200 mixed warmup"),
            SetComponent(type: .swim, distance: 500, strokeStyle: .butterfly, instructions: "5x100 butterfly on 2:00"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .mixed, instructions: "200 easy cool down"),
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.intermediate, description: "Building strength and technique in butterfly.", primaryStroke: [.butterfly]),
        SwimSet(title: "Stroke Variety Pack", components: [
            SetComponent(type: .warmup, distance: 100, strokeStyle: .mixed, instructions: "100 IM warmup"),
            SetComponent(type: .swim, distance: 200, strokeStyle: .mixed, instructions: "4x50 each stroke focus"),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .mixed, instructions: "100 easy cooldown"),
        ], measureUnit: .yards, difficulty: SwimSet.Difficulty.beginner, description: "Introduction to all strokes, focusing on transitions.", primaryStroke: [.butterfly, .backstroke, .breaststroke, .freestyle]),
        SwimSet(title: "Breaststroke Endurance", components: [
            SetComponent(type: .warmup, distance: 500, strokeStyle: .mixed, instructions: "500 warmup"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .breaststroke, instructions: "10x100 on 1:50"),
            SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down"),
        ], measureUnit: .meters, difficulty: SwimSet.Difficulty.advanced, description: "Long distance, endurance training for breaststroke.", primaryStroke: [.breaststroke]),
    ]

    // init
    override init()
    {
        healthStore = HKHealthStore()
        permission = true
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
            loadFromJSON() // attempt to load from JSON

            // check if the swims are empty after attempting to load
            if swims.isEmpty
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

    func loadAllSwimmingWorkouts()
    {
        swims.removeAll()

        let predicate = HKQuery.predicateForWorkouts(with: .swimming)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let workoutType = HKObjectType.workoutType()

        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        )
        { [weak self] _, samples, error in
            guard let self = self else { return }

            if let error
            { // 1️⃣ handle the error first
                os_log("HealthKit error: %@", type: .error, error.localizedDescription)
            }

            guard let workouts = samples as? [HKWorkout], !workouts.isEmpty else { return }

            // 2️⃣ heavy work off‑main
            let parsed: [Swim] = workouts.compactMap
            { workout in
                self.buildSwim(from: workout)
            }

            // 3️⃣ UI / model mutation on the main queue
            DispatchQueue.main.async
            {
                self.swims = parsed
                self.calcFields()
                self.updateStore()
            }
        }

        healthStore.execute(query)
    }

    /// Converts `HKWorkout` → your `Swim` model.
    /// Runs on a background queue, so *don't* touch UIKit here.
    private func buildSwim(from workout: HKWorkout) -> Swim
    {
        // Figure out pool length & unit **first**
        let (poolLength, poolUnit) = poolInfo(from: workout.metadata)

        // Choose the unit we'll use for distance
        let distanceUnit: HKUnit =
        {
            switch poolUnit
            {
            case .yards: return .yard()
            case .meters, .none: fallthrough
            default: return .meter()
            }
        }()

        // Pull the value in that unit
        let totalDistance = workout.totalDistance?
            .doubleValue(for: distanceUnit) ?? 0

        let totalEnergy = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0

        // Location
        let locationType: SwimmingLocationType =
        {
            guard
                let raw = workout.metadata?[HKMetadataKeySwimmingLocationType] as? NSNumber,
                let hk = HKWorkoutSwimmingLocationType(rawValue: raw.intValue)
            else { return .unknown }

            switch hk
            {
            case .pool: return .pool
            case .openWater: return .openWater
            default: return .unknown
            }
        }()

        // Lap events
        let laps: [Lap] = workout.workoutEvents?
            .filter { $0.type == .lap }
            .map { Lap(startDate: $0.dateInterval.start,
                       endDate: $0.dateInterval.end,
                       metadata: $0.metadata ?? [:]) } ?? []

        return Swim(
            id: workout.uuid, // stable
            startDate: workout.startDate,
            endDate: workout.endDate, // use HK's value
            totalDistance: totalDistance,
            totalEnergyBurned: totalEnergy,
            poolLength: poolLength,
            locationType: locationType,
            poolUnit: poolUnit,
            laps: laps
        )
    }

    /// Returns lap length + unit, or (nil, nil) if unknown.
    private func poolInfo(from metadata: [String: Any]?) -> (Double?, MeasureUnit?)
    {
        guard let q = metadata?[HKMetadataKeyLapLength] as? HKQuantity
        else
        {
            return (nil, nil)
        }

        let yd = q.doubleValue(for: .yard())
        let m = q.doubleValue(for: .meter())

        func isNearInt(_ x: Double, tol: Double = 0.05) -> Bool
        {
            abs(x.rounded() - x) < tol
        }

        let looksYards = isNearInt(yd) // 24 yd, 25 yd, 50 yd …
        let looksMetres = isNearInt(m) || abs(m - 33.33) < 0.05 // 25 m, 50 m, 33.33 m

        switch (looksYards, looksMetres)
        {
        case (true, false): return (yd, .yards)
        case (false, true): return (m, .meters)
        case (true, true): // 25 yd vs 25 m clash → prefer metres
            return (m, .meters)
        default: return (m, .meters) // safest fall‑back
        }
    }

    // calcs user totals
    func calcFields()
    {
        let unit = preferredUnit // user setting in Settings screen

        var tDist = 0.0
        var tCal = 0.0

        for swim in swims
        {
            let distanceHKUnit: HKUnit = (swim.poolUnit == .yards) ? .yard() : .meter()
            let baseValue = swim.totalDistance ?? 0

            // Convert everything into the preferred unit before adding
            let converted = Measurement(value: baseValue,
                                        unit: distanceHKUnit == .yard() ? UnitLength.yards
                                            : UnitLength.meters)
                .converted(to: unit == .yards ? UnitLength.yards : UnitLength.meters)
            tDist += converted.value

            tCal += swim.totalEnergyBurned ?? 0
        }

        totalDistance = tDist
        averageDistance = swims.isEmpty ? 0 : tDist / Double(swims.count)
        totalCalories = tCal
        averageCalories = swims.isEmpty ? 0 : tCal / Double(swims.count)
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
        swims = store.swims
        userName = store.userName
        preferredStroke = store.preferredStroke
        preferredUnit = store.preferredUnit
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
    var preferredStroke: SwimStroke?
    var preferredUnit: MeasureUnit
    var swims: [Swim]
}
