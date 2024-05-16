//
//  UnitPickerView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

struct UnitPickerView: View 
{
    @EnvironmentObject var manager: WatchManager

    var body: some View
    {
        VStack 
        {
            Button("Meters")
            {
                manager.poolUnit = "meters"
            }


            Button("Yards") 
            {
                manager.poolUnit  = "yards"
            }

        }
    }
}
