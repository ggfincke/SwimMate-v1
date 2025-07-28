// SwimMate/ViewModel/Extensions/Manager+WorkoutAnalysis.swift

import Foundation

extension Manager
{
    func groupLapsByRestPeriods(_ laps: [Lap], poolLength _: Double) -> [WorkoutSet]
    {
        guard !laps.isEmpty else { return [] }

        // Step 1: Create consecutive swims based on rest periods
        var consecutiveSwims: [ConsecutiveSwim] = []
        var currentSwimLaps: [Lap] = [laps[0]]
        var currentStartLap = 1

        for i in 1 ..< laps.count
        {
            let previousLap = laps[i - 1]
            let currentLap = laps[i]
            let restPeriod = previousLap.restPeriodTo(currentLap)

            // If rest period is short and same stroke, add to current swim
            if restPeriod <= ConsecutiveSwim.consecutiveThreshold,
               currentLap.stroke == previousLap.stroke
            {
                currentSwimLaps.append(currentLap)
            }
            else
            {
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

        for i in 0 ..< consecutiveSwims.count
        {
            let currentSwim = consecutiveSwims[i]

            if currentSetSwims.isEmpty
            {
                // Start new set
                currentSetSwims = [currentSwim]
            }
            else
            {
                let previousSwim = currentSetSwims.last!

                // Calculate rest between the end of previous swim and start of current swim
                let restBetweenSwims: TimeInterval
                if let lastLapOfPrevious = previousSwim.laps.last,
                   let firstLapOfCurrent = currentSwim.laps.first
                {
                    restBetweenSwims = firstLapOfCurrent.startDate.timeIntervalSince(lastLapOfPrevious.endDate)
                }
                else
                {
                    restBetweenSwims = 0
                }

                // Check if swims are similar and rest is reasonable
                let sameStroke = currentSwim.effectiveStrokeStyle == previousSwim.effectiveStrokeStyle
                let similarLapCount = abs(currentSwim.laps.count - previousSwim.laps.count) <= 1
                let reasonableRest = restBetweenSwims <= ConsecutiveSwim.setThreshold

                if sameStroke, similarLapCount, reasonableRest
                {
                    currentSetSwims.append(currentSwim)
                }
                else
                {
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
        if !currentSetSwims.isEmpty
        {
            workoutSets.append(WorkoutSet(
                consecutiveSwims: currentSetSwims,
                setNumber: setNumber
            ))
        }

        return workoutSets
    }
}
