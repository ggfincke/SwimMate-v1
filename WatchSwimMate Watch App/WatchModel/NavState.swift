// WatchSwimMate Watch App/WatchModel/NavState.swift

// navigation states for use in the navigation stack
import Foundation
import SwiftUI

enum NavState: Hashable
{
    case swimSetup
    case goalSwimSetup
    case indoorPoolSetup
    case swimmingView(set: SwimSet?)
    case importSetView
}
