// SwimMate/Model/Sets/SetComponent.swift

import Foundation

/// Individual component within a swim set (e.g., swim, drill, kick, etc.)
struct SetComponent: Identifiable, Hashable, Codable
{
    // MARK: - Properties
    let id: UUID
    let type: ComponentType
    let distance: Int
    let strokeStyle: StrokeStyle?
    let instructions: String?
    let restPeriod: TimeInterval? // rest after this part of set
    
    // MARK: - Component Types
    enum ComponentType: String, CaseIterable, Codable
    {
        case swim = "Swim"
        case drill = "Drill"
        case kick = "Kick"
        case pull = "Pull"
        case warmup = "Warmup"
        case cooldown = "Cooldown"
        
        var description: String 
        {
            return rawValue
        }
    }
    
    // MARK: - Initialization
    init(id: UUID = UUID(),
         type: ComponentType,
         distance: Int,
         strokeStyle: StrokeStyle? = nil,
         instructions: String? = nil,
         restPeriod: TimeInterval? = nil)
    {
        self.id = id
        self.type = type
        self.distance = distance
        self.strokeStyle = strokeStyle
        self.instructions = instructions
        self.restPeriod = restPeriod
    }
    
    // MARK: - Methods
    func displayTitle(poolLength: Double, measureUnit: MeasureUnit) -> String
    {
        let distanceText = "\(distance)\(measureUnit.abbreviation)"
        
        if let stroke = strokeStyle
        {
            return "\(distanceText) \(stroke.description) \(type.description)"
        } 
        else 
        {
            return "\(distanceText) \(type.description)"
        }
    }
    
    /// Calculate number of laps for this component
    func lapCount(poolLength: Double, measureUnit: MeasureUnit) -> Int
    {
        let distanceInMeters = measureUnit == .meters ? Double(distance) : Double(distance) * 0.9144 // yards to meters
        return Int(ceil(distanceInMeters / poolLength))
    }
} 