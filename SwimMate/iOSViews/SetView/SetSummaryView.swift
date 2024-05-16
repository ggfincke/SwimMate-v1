//
//  SetSummaryView.swift
//  SwimMate
//
//  Created by Garrett Fincke on 4/29/24.
//

import SwiftUI

struct SetSummaryView: View
{
    let swimmySet : SwimSet
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text(swimmySet.title).font(.headline)
            Text("\(swimmySet.totalDistance) \(swimmySet.measureUnit.rawValue) - \(swimmySet.primaryStroke.rawValue)")
            Text(swimmySet.description).font(.subheadline)
        }
    }
}


