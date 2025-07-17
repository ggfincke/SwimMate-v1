// SwimMate/iOSViews/SwimViews/WorkoutView/Sections/LapDetailsSection.swift

import SwiftUI


// MARK: - Lap Details Section
struct LapDetailsSection: View
{
    let swim: Swim
    
    private var lapGroups: [LapGroup] {
        groupConsecutiveLaps(swim.laps)
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
                        ForEach(Array(lapGroups.enumerated()), id: \.offset) { index, group in
                            LapGroupRow(
                                setNumber: index + 1,
                                lapGroup: group
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
    
    // MARK: - Helper function to group consecutive laps
    private func groupConsecutiveLaps(_ laps: [Lap]) -> [LapGroup] {
        guard !laps.isEmpty else { return [] }
        
        var groups: [LapGroup] = []
        var currentGroup: [Lap] = [laps[0]]
        var currentStroke = laps[0].strokeStyle
        var startLapNumber = 1
        
        for i in 1..<laps.count {
            let lap = laps[i]
            
            // If same stroke as current group, add to group
            if lap.strokeStyle == currentStroke {
                currentGroup.append(lap)
            } else {
                // Different stroke, finalize current group and start new one
                groups.append(LapGroup(
                    strokeStyle: currentStroke,
                    laps: currentGroup,
                    startLapNumber: startLapNumber
                ))
                
                currentGroup = [lap]
                currentStroke = lap.strokeStyle
                startLapNumber = i + 1
            }
        }
        
        // Don't forget the last group
        groups.append(LapGroup(
            strokeStyle: currentStroke,
            laps: currentGroup,
            startLapNumber: startLapNumber
        ))
        
        return groups
    }
}

// MARK: - Lap Group Row View
struct LapGroupRow: View {
    let setNumber: Int
    let lapGroup: LapGroup
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
                    Text(lapGroup.displayTitle)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    if lapGroup.laps.count > 1 {
                        Button(action: { isExpanded.toggle() }) {
                            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(format: "%.1fs", lapGroup.averageTime))
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(width: 70, alignment: .trailing)
                
                Text(lapGroup.averageSwolf != nil ? String(format: "%.1f", lapGroup.averageSwolf!) : "—")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(lapGroup.averageSwolf != nil ? .white : .secondary)
                    .frame(width: 80, alignment: .trailing)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(setNumber % 2 == 0 ? Color.clear : Color.secondary.opacity(0.05))
            .contentShape(Rectangle())
            .onTapGesture {
                if lapGroup.laps.count > 1 {
                    isExpanded.toggle()
                }
            }
            
            // Expanded individual laps
            if isExpanded && lapGroup.laps.count > 1 {
                VStack(spacing: 1) {
                    ForEach(Array(lapGroup.laps.enumerated()), id: \.offset) { index, lap in
                        HStack {
                            Text("  \(lapGroup.startLapNumber + index)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                                .frame(width: 60, alignment: .leading)
                            
                            Text("Individual Lap")
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

#Preview
{
    let sampleLaps = [
        Lap(duration: 45.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.5]),
        Lap(duration: 42.1, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 26.8]),
        Lap(duration: 44.7, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 29.2]),
        Lap(duration: 43.8, metadata: ["HKSwimmingStrokeStyle": 3, "HKSWOLFScore": 31.1]),
        Lap(duration: 46.3, metadata: ["HKSwimmingStrokeStyle": 4, "HKSWOLFScore": 30.5]),
        Lap(duration: 41.9, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 27.3]),
        Lap(duration: 48.1, metadata: ["HKSwimmingStrokeStyle": 5, "HKSWOLFScore": 32.8]),
        Lap(duration: 44.2, metadata: ["HKSwimmingStrokeStyle": 2, "HKSWOLFScore": 28.9])
    ]

    let sampleSwim = Swim(
        id: UUID(),
        date: Date(),
        duration: 1920,
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
