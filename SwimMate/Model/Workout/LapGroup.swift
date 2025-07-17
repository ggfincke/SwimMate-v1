import Foundation

// MARK: - ConsecutiveSwim
/// Consecutive Swim: a group of laps performed with minimal rest (e.g., 4x25m = 100m swim)
struct ConsecutiveSwim: Hashable, Codable
{
    let laps: [Lap]
    let strokeStyle: StrokeStyle?
    let startLapNumber: Int
    
    // MARK: - Constants
    /// Rest threshold in seconds - laps with rest <= this are considered consecutive
    static let consecutiveThreshold: TimeInterval = 5.0
    /// Set threshold in seconds - swims with rest > this are considered separate sets
    static let setThreshold: TimeInterval = 60.0
    
    // MARK: - Initialization
    init(laps: [Lap], startLapNumber: Int)
    {
        self.laps = laps
        self.strokeStyle = laps.first?.strokeStyle
        self.startLapNumber = startLapNumber
    }
    
    // MARK: - Computed Properties
    var totalTime: TimeInterval
    {
        laps.reduce(0) { $0 + $1.duration }
    }
    
    var averageTime: TimeInterval
    {
        guard !laps.isEmpty else { return 0 }
        return totalTime / Double(laps.count)
    }
    
    var averageSwolf: Double?
    {
        let scores = laps.compactMap { $0.swolfScore }
        guard !scores.isEmpty else { return nil }
        return scores.reduce(0, +) / Double(scores.count)
    }
    
    var isIndividualMedley: Bool
    {
        guard laps.count == 4 else { return false }
        
        let expectedSequence: [StrokeStyle] = [.butterfly, .backstroke, .breaststroke, .freestyle]
        let actualSequence = laps.compactMap { $0.strokeStyle }
        
        return actualSequence == expectedSequence
    }
    
    var effectiveStrokeStyle: StrokeStyle?
    {
        if isIndividualMedley
        {
            return .mixed // Treating IM as mixed
        }
        return strokeStyle
    }
    
    // MARK: - Methods
    func displayTitle(poolLength: Double) -> String
    {
        let count = laps.count
        
        // Handle Individual Medley
        if isIndividualMedley
        {
            let totalDistance = Double(count) * poolLength
            let distanceInt = Int(totalDistance)
            return "\(distanceInt)m IM"
        }
        
        let strokeName = strokeStyle?.description ?? "Unknown"
        
        if count == 1
        {
            return strokeName
        }
        else
        {
            // For multiple laps, show as distance using actual pool length
            let totalDistance = Double(count) * poolLength
            let distanceInt = Int(totalDistance)
            return "\(distanceInt)m \(strokeName)"
        }
    }
}

// MARK: - WorkoutSet
/// WorkoutSet: a group of similar ConsecutiveSwims (e.g., 4x100m freestyle set)
struct WorkoutSet: Hashable, Codable
{
    let consecutiveSwims: [ConsecutiveSwim]
    let strokeStyle: StrokeStyle?
    let setNumber: Int
    
    // MARK: - Initialization
    init(consecutiveSwims: [ConsecutiveSwim], setNumber: Int)
    {
        self.consecutiveSwims = consecutiveSwims
        self.strokeStyle = consecutiveSwims.first?.effectiveStrokeStyle
        self.setNumber = setNumber
    }
    
    // MARK: - Computed Properties
    var totalTime: TimeInterval
    {
        consecutiveSwims.reduce(0) { $0 + $1.totalTime }
    }
    
    var averageTime: TimeInterval
    {
        guard !consecutiveSwims.isEmpty else { return 0 }
        return totalTime / Double(consecutiveSwims.count)
    }

    var averageSwolf: Double?
    {
        let allSwolfs = consecutiveSwims.compactMap { $0.averageSwolf }
        guard !allSwolfs.isEmpty else { return nil }
        return allSwolfs.reduce(0, +) / Double(allSwolfs.count)
    }
    
    // MARK: - Methods
    func displayTitle(poolLength: Double) -> String
    {
        let count = consecutiveSwims.count
        let strokeName = strokeStyle?.description ?? "Unknown"
        
        if count == 1
        {
            return consecutiveSwims.first?.displayTitle(poolLength: poolLength) ?? strokeName
        }
        else
        {
            // For sets with multiple swims, show count & first swim format
            if let firstSwim = consecutiveSwims.first
            {
                let individualLapCount = firstSwim.laps.count
                if individualLapCount > 1
                {
                    let distance = Int(Double(individualLapCount) * poolLength)
                    return "\(count)x\(distance)m \(strokeName)"
                }
                else
                {
                    let distance = Int(poolLength)
                    return "\(count)x\(distance)m \(strokeName)"
                }
            }
            return "\(count)x \(strokeName)"
        }
    }
}
