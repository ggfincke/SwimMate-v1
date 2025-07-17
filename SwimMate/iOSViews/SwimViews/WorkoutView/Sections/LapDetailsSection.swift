// SwimMate/iOSViews/SwimViews/WorkoutView/Sections/LapDetailsSection.swift

import SwiftUI


// MARK: - Lap Details Section
struct LapDetailsSection: View
{
    let swim: Swim
    
    private var workoutSets: [WorkoutSet] {
        groupLapsByRestPeriods(swim.laps, poolLength: swim.poolLength ?? 25.0)
    }
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 12)
        {
            HStack
            {
                Image(systemName: "list.bullet")
                    .foregroundColor(.blue)
                    .font(.headline)
                
                Text("Set Details")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 1)
            {
                // Header
                HStack {
                    Text("Set")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .leading)
                    
                    Text("Type")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Avg Time")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 70, alignment: .trailing)
                    
                    Text("Avg SWOLF")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 80, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                
                // Set groups - scrollable for large datasets
                ScrollView
                {
                    LazyVStack(spacing: 1)
                    {
                        ForEach(Array(workoutSets.enumerated()), id: \.offset) { index, set in
                            WorkoutSetRow(
                                setNumber: index + 1,
                                workoutSet: set,
                                poolLength: swim.poolLength ?? 25.0
                            )
                        }
                    }
                }
                .frame(maxHeight: 300) // Limit height for better scaling
            }
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Helper function to group laps by rest periods
    private func groupLapsByRestPeriods(_ laps: [Lap], poolLength: Double) -> [WorkoutSet] {
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
               currentLap.strokeStyle == previousLap.strokeStyle {
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

// MARK: - Workout Set Row View
struct WorkoutSetRow: View {
    let setNumber: Int
    let workoutSet: WorkoutSet
    let poolLength: Double
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main set row
            HStack {
                Text("\(setNumber)")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(width: 60, alignment: .leading)
                
                HStack {
                    Text(workoutSet.displayTitle(poolLength: poolLength))
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    // Show expand button if there are multiple consecutive swims or laps
                    if workoutSet.consecutiveSwims.count > 1 || 
                       workoutSet.consecutiveSwims.first?.laps.count ?? 0 > 1 {
                        Button(action: { isExpanded.toggle() }) {
                            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(format: "%.1fs", workoutSet.averageTime))
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(width: 70, alignment: .trailing)
                
                Text(workoutSet.averageSwolf != nil ? String(format: "%.1f", workoutSet.averageSwolf!) : "—")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(workoutSet.averageSwolf != nil ? .white : .secondary)
                    .frame(width: 80, alignment: .trailing)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(setNumber % 2 == 0 ? Color.clear : Color.secondary.opacity(0.05))
            .contentShape(Rectangle())
            .onTapGesture {
                if workoutSet.consecutiveSwims.count > 1 || 
                   workoutSet.consecutiveSwims.first?.laps.count ?? 0 > 1 {
                    isExpanded.toggle()
                }
            }
            
            // Expanded consecutive swims and individual laps
            if isExpanded {
                VStack(spacing: 1) {
                    ForEach(Array(workoutSet.consecutiveSwims.enumerated()), id: \.offset) { swimIndex, consecutiveSwim in
                        // Show individual consecutive swim if multiple swims in set
                        if workoutSet.consecutiveSwims.count > 1 {
                            HStack {
                                Text("  \(swimIndex + 1)")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                                    .frame(width: 60, alignment: .leading)
                                
                                Text(consecutiveSwim.displayTitle(poolLength: poolLength))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(String(format: "%.1fs", consecutiveSwim.averageTime))
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                                    .frame(width: 70, alignment: .trailing)
                                
                                Text(consecutiveSwim.averageSwolf != nil ? String(format: "%.1f", consecutiveSwim.averageSwolf!) : "—")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                                    .frame(width: 80, alignment: .trailing)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.02))
                        }
                        
                        // Show individual laps if consecutive swim has multiple laps
                        if consecutiveSwim.laps.count > 1 {
                            ForEach(Array(consecutiveSwim.laps.enumerated()), id: \.offset) { lapIndex, lap in
                                HStack {
                                    Text("    \(consecutiveSwim.startLapNumber + lapIndex)")
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(.secondary)
                                        .frame(width: 60, alignment: .leading)
                                    
                                    Text("Lap \(lapIndex + 1)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(String(format: "%.1fs", lap.duration))
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(.secondary)
                                        .frame(width: 70, alignment: .trailing)
                                    
                                    Text(lap.swolfScore != nil ? String(format: "%.1f", lap.swolfScore!) : "—")
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(.secondary)
                                        .frame(width: 80, alignment: .trailing)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .background(Color.secondary.opacity(0.02))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview
{
    let baseDate = Date()
    let sampleLaps = [
        // 4x25m Freestyle (consecutive with short rest)
        Lap(startDate: baseDate, endDate: baseDate.addingTimeInterval(25.2), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(startDate: baseDate.addingTimeInterval(30), endDate: baseDate.addingTimeInterval(55.1), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(startDate: baseDate.addingTimeInterval(60), endDate: baseDate.addingTimeInterval(84.7), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(startDate: baseDate.addingTimeInterval(90), endDate: baseDate.addingTimeInterval(113.8), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 31.1]),
        
        // Individual Medley (100m: Butterfly->Back->Breast->Free) after 1 min rest  
        Lap(startDate: baseDate.addingTimeInterval(180), endDate: baseDate.addingTimeInterval(215.3), metadata: ["HKSwimmingStrokeStyle": 5, "HKSWOLFScore": 35.5]), // Butterfly
        Lap(startDate: baseDate.addingTimeInterval(220), endDate: baseDate.addingTimeInterval(250.9), metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 32.3]), // Backstroke  
        Lap(startDate: baseDate.addingTimeInterval(255), endDate: baseDate.addingTimeInterval(290.1), metadata: ["HKSwimmingStrokeStyle": 4, "HKSWOLFScore": 34.8]), // Breaststroke
        Lap(startDate: baseDate.addingTimeInterval(295), endDate: baseDate.addingTimeInterval(320.2), metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.9])  // Freestyle
    ]

    let sampleSwim = Swim(
        id: UUID(),
        startDate: Date(),
        endDate: Date().addingTimeInterval(1920),
        totalDistance: 1425,
        totalEnergyBurned: 289,
        poolLength: 25.0,
        laps: sampleLaps
    )

    return VStack {
        LapDetailsSection(swim: sampleSwim)
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
