//
//  ImportSetView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/28/24.
//

import SwiftUI
import HealthKit


struct ImportSetView: View
{
    @EnvironmentObject var watchConnector: iOSWatchConnector
    @EnvironmentObject var manager: WatchManager

    var body: some View 
    {
        List(watchConnector.receivedSets, id: \.self)
        { swimSet in
            NavigationLink(destination: IndoorPoolSetupView(swimmySet: swimSet).environmentObject(watchConnector)
                .environmentObject(manager))
            {
                VStack(alignment: .leading)
                {
                    Text(swimSet.title).font(.headline)
                    Text("\(swimSet.totalDistance) \(swimSet.measureUnit.rawValue) - \(swimSet.primaryStroke.rawValue)")
                }
            }
        }
        .navigationTitle("Imported Sets")
    }
}




#Preview {
    ImportSetView()
        .environmentObject(iOSWatchConnector())
        .environmentObject(WatchManager())

}
