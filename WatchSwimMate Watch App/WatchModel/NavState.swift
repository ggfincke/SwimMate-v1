//
//  NavState.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 5/15/24.
//

import Foundation
import SwiftUI

enum NavState: Hashable
{
    case workoutSetup
    case indoorPoolSetup
    case swimmingView(set: SwimSet?)
    case importSetView
}
