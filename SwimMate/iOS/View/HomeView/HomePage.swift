//
//  HomePage.swift
//  SwimMate
//
//  Created by Garrett Fincke on 4/14/24.
//

import SwiftUI

// homepage
struct HomePage: View
{
    @EnvironmentObject var manager : Manager

    var body: some View
    {
        VStack
        {
            Text("SwimMate")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
            WeekView()
                .padding(.bottom, -20)
            ChartView()
                .environmentObject(manager)
                .padding()
            WorkoutHistoryView()
            
        }
    }
}

//#Preview {
//    HomePage()
//        .environmentObject(Manager(withTestData: true))
//}
