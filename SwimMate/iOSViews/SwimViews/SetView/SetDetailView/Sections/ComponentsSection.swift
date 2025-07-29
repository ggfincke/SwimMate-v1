// SwimMate/iOSViews/SwimViews/SetView/SetDetailView/Sections/ComponentsSection.swift

import SwiftUI

struct ComponentsSection: View
{
    let components: [SetComponent]

    var body: some View
    {
        VStack(alignment: .leading, spacing: 16)
        {
            Text("Workout Components")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            VStack(spacing: 12)
            {
                ForEach(Array(components.enumerated()), id: \.element.id)
                { index, component in
                    ComponentCard(component: component, index: index + 1)
                }
            }
        }
    }
}

#Preview
{
    let sampleComponents = [
        SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix - easy pace"),
        SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30, descend 1-5, 6-10"),
        SetComponent(type: .kick, distance: 500, strokeStyle: .kickboard, instructions: "10x50 kick on 1:00"),
        SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down easy")
    ]
    
    ComponentsSection(components: sampleComponents)
        .padding()
}