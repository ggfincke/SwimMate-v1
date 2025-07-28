// toiOSWatchConnector

import Foundation
import Observation
import WatchConnectivity

@Observable
class iOSWatchConnector: NSObject, WCSessionDelegate
{
    var session: WCSession
    // received sets from iOS
    var receivedSets: [SwimSet] = []

    init(session: WCSession = .default)
    {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

    // MARK: - WCSessionDelegate Methods

    func session(_: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
    {
        if let error = error
        {
            print("WC Session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: \(activationState)")
    }

    func session(_: WCSession, didReceiveMessage message: [String: Any])
    {
        // handle incoming message data, assuming data keys match those sent by iOS
        if let title = message["title"] as? String,
           let strokeRaw = message["stroke"] as? String,
           let totalDistance = message["totalDistance"] as? Int,
           let measureUnitRaw = message["measureUnit"] as? String,
           let difficultyRaw = message["difficulty"] as? String,
           let description = message["description"] as? String,
           let details = message["details"] as? [String]
        {
            // Map stroke string to SwimStroke enum
            let primaryStroke: SwimStroke = {
                switch strokeRaw.lowercased()
                {
                case "freestyle": return .freestyle
                case "backstroke": return .backstroke
                case "breaststroke": return .breaststroke
                case "butterfly": return .butterfly
                case "kickboard": return .kickboard
                case "mixed": return .mixed
                default: return .freestyle
                }
            }()

            let measureUnit = MeasureUnit(rawValue: measureUnitRaw) ?? .meters
            let difficulty = SwimSet.Difficulty(rawValue: difficultyRaw) ?? .intermediate

            // Create a single SetComponent representing the entire set
            let setComponent = SetComponent(
                type: .swim,
                distance: totalDistance,
                strokeStyle: primaryStroke,
                instructions: details.joined(separator: " • ")
            )

            let newSet = SwimSet(
                title: title,
                components: [setComponent],
                measureUnit: measureUnit,
                difficulty: difficulty,
                description: description
            )

            receivedSets.append(newSet)
        }
    }

    // TODO: will need to add a func for sending data back to watch
    // should the swim struct store a corresponding set if completed in the watchOS app?
}
