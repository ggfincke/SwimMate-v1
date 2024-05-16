////
////  CalorieSetupView.swift
////  WatchSwimMate Watch App
////
////  Created by Garrett Fincke on 4/27/24.
////
//
//import SwiftUI
//
//struct CalorieSetupView: View {
//    @EnvironmentObject var manager: WatchManager
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Set Calorie Goal")
//                .font(.headline)
//
//            TextField("Enter calories", value: $manager.goalCalories, formatter: NumberFormatter())
//                .padding()
//
//            Button("Start Workout") {
//                manager.startWorkout()
//            }
//            .padding()
//            .background(Color.green)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//        .padding()
//    }
//}
//
//
//#Preview {
//    CalorieSetupView()
//}
