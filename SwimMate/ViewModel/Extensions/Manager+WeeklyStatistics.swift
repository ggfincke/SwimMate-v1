// SwimMate/ViewModel/Extensions/Manager+WeeklyStatistics.swift

import Foundation

extension Manager 
{
    func weeklyStats() -> (workouts: Int, distance: Double, time: TimeInterval)
    {
        let calendar = Calendar.current
        let now = Date()
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start else 
        {
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
              let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) else 
        {
            return "stable"
        }
        
        let thisWeekWorkouts = swims.filter { $0.date >= thisWeekStart }.count
        let lastWeekWorkouts = swims.filter { $0.date >= lastWeekStart && $0.date < thisWeekStart }.count
        
        if thisWeekWorkouts > lastWeekWorkouts 
        {
            return "up"
        } 
        else if thisWeekWorkouts < lastWeekWorkouts 
        {
            return "down"
        } 
        else 
        {
            return "stable"
        }
    }
    
    func weeklyDistanceTrend() -> String
    {
        let calendar = Calendar.current
        let now = Date()
        
        guard let thisWeekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start,
              let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) else 
        {
            return "stable"
        }
        
        let thisWeekDistance = swims.filter { $0.date >= thisWeekStart }.compactMap { $0.totalDistance }.reduce(0, +)
        let lastWeekDistance = swims.filter { $0.date >= lastWeekStart && $0.date < thisWeekStart }.compactMap { $0.totalDistance }.reduce(0, +)
        
        if thisWeekDistance > lastWeekDistance 
        {
            return "up"
        } 
        else if thisWeekDistance < lastWeekDistance 
        {
            return "down"
        } 
        else 
        {
            return "stable"
        }
    }
    
    func weeklyTimeTrend() -> String
    {
        let calendar = Calendar.current
        let now = Date()
        
        guard let thisWeekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start,
              let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) else 
        {
            return "stable"
        }
        
        let thisWeekTime = swims.filter { $0.date >= thisWeekStart }.reduce(0) { $0 + $1.duration }
        let lastWeekTime = swims.filter { $0.date >= lastWeekStart && $0.date < thisWeekStart }.reduce(0) { $0 + $1.duration }
        
        if thisWeekTime > lastWeekTime 
        {
            return "up"
        } 
        else if thisWeekTime < lastWeekTime 
        {
            return "down"
        } 
        else 
        {
            return "stable"
        }
    }
}