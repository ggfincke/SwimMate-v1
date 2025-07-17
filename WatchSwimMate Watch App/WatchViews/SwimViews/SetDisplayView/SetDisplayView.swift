// SetDisplayView.swift

import SwiftUI

// main view
struct SetDisplayView: View
{
    let swimSet: SwimSet
    @State private var currentIndex = 0
    @Environment(\.dismiss) private var dismiss
    
    // computed property to get step details from components
    private var stepDetails: [String] {
        swimSet.components.compactMap { $0.instructions }
    }
    
    // is the set is completed or not
    private var isCompleted: Bool
    {
        currentIndex >= stepDetails.count
    }
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            // set is completed
            if isCompleted
            {
                
                SetCompletionView
                {
                    // auto-dismiss to show workout summary
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                    {
                        dismiss()
                    }
                }
                .padding(.horizontal, 12)
            }
            // else main content
            else
            {
                // header with set & current steps
                SetHeader(
                    swimSet: swimSet,
                    currentStep: min(currentIndex + 1, stepDetails.count),
                    totalSteps: stepDetails.count
                )
                .padding(.horizontal, 8)
                .padding(.top, 4)
                
                Spacer()
                
                StepView(
                    step: stepDetails[currentIndex],
                    stepNumber: currentIndex + 1,
                    totalSteps: stepDetails.count
                )
                .padding(.horizontal, 12)
            }
            
            Spacer()
            
            // main navigation
            if !isCompleted
            {
                NavigationControls(
                    currentIndex: $currentIndex,
                    totalSteps: stepDetails.count
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }
        }
    }
}

// preview
#Preview
{
    let sampleSet = SwimSet(
        title: "Endurance Builder",
        components: [
            SetComponent(type: .warmup, distance: 400, strokeStyle: .mixed, instructions: "400m warm-up easy mixed strokes"),
            SetComponent(type: .swim, distance: 800, strokeStyle: .freestyle, instructions: "8x100m freestyle on 1:30 - build each 100m"),
            SetComponent(type: .swim, distance: 800, strokeStyle: .freestyle, instructions: "4x200m freestyle on 3:00 - steady pace"),
            SetComponent(type: .kick, distance: 400, strokeStyle: .kickboard, instructions: "8x50m kick with board on 1:00"),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .backstroke, instructions: "200m cool down easy backstroke")
        ],
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "Progressive endurance set"
    )
    
    SetDisplayView(swimSet: sampleSet)
}
