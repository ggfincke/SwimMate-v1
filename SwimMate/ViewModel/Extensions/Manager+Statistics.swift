// SwimMate/ViewModel/Extensions/Manager+Statistics.swift

import Foundation

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
        { 
            return "N/A" 
        }
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
        
        if distanceProgress >= 100 && workoutProgress >= 100 
        {
            return "🎉 Goals achieved!"
        } 
        else if distanceProgress >= 100 
        {
            return "Distance goal reached! \(weeklyGoalWorkouts - currentWorkouts) workouts to go"
        } 
        else if workoutProgress >= 100 
        {
            return "Workout goal reached! \(Int(weeklyGoalDistance - currentDistance))m to go"
        } 
        else 
        {
            return "\(Int(distanceProgress))% distance, \(Int(workoutProgress))% workouts"
        }
    }
}