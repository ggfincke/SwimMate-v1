// SwimMate/iOSViews/SwimViews/SetView/SetDetailView.swift

import SwiftUI

struct SetDetailView: View 
{
    let swimSet: SwimSet
    @EnvironmentObject var watchConnector: WatchConnector
    
    var body: some View 
    {
        
        VStack
        {
            List
            {
                Text(swimSet.title).font(.headline)
                
                // basic info
                Section(header: Text("Overview")) {
                    Text("Stroke: \(swimSet.primaryStroke?.description ?? "Mixed")")
                    Text("Total Distance: \(swimSet.totalDistance) \(swimSet.measureUnit.rawValue)")
                    Text("Difficulty: \(swimSet.difficulty.rawValue)")
                }
                
                // desc
                Section(header: Text("Description")) {
                    Text(swimSet.description ?? "No description available")
                        .fixedSize(horizontal: false, vertical: true)
                    // ensure  text does not get truncated
                }
                
                // the actual set
                Section(header: Text("Set:")) {
                    ForEach(swimSet.components, id: \.id) { component in
                        if let instructions = component.instructions {
                            Text(instructions)
                        }
                    }
                }
            }
            .navigationTitle("\(swimSet.primaryStroke?.description ?? "Mixed") Set")

            Button(action: {
                watchConnector.sendSwimSet(swimSet: swimSet)
            })
            {
                HStack 
                {
                    Image(systemName: "paperplane.fill")
                    Text("Send to Watch")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
    }
}

// Preview of the SetDetailView
struct SetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSet = SwimSet(
            title: "Sample",
            components: [
                SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix"),
                SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30, descend 1-5, 6-10"),
                SetComponent(type: .kick, distance: 500, strokeStyle: .kickboard, instructions: "10x50 kick on 1:00"),
                SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down easy")
            ],
            measureUnit: .meters,
            difficulty: .intermediate,
            description: "A challenging set designed to improve endurance and pace."
        )
        SetDetailView(swimSet: sampleSet)
    }
}


//#Preview
//{
//    let sSet = SwimSet(
//        title: "Quick Set",
//        components: [
//            SetComponent(type: .swim, distance: 200, strokeStyle: .freestyle, instructions: "8x25s Freestyle on 30 seconds"),
//            SetComponent(type: .cooldown, distance: 50, strokeStyle: .mixed, instructions: "2x25s easy")
//        ],
//        measureUnit: .meters,
//        difficulty: .beginner
//    )
//
//    SetDetailView(swimSet: sSet)
//}
