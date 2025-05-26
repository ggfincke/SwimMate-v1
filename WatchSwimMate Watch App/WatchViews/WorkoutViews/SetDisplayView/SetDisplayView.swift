// SetDisplayView.swift

import SwiftUI

// main view
struct SetDisplayView: View
{
    let swimSet: SwimSet
    @State private var currentIndex = 0
    @Environment(\.dismiss) private var dismiss
    
    // is the set is completed or not
    private var isCompleted: Bool
    {
        currentIndex >= swimSet.details.count
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
                    currentStep: min(currentIndex + 1, swimSet.details.count),
                    totalSteps: swimSet.details.count
                )
                .padding(.horizontal, 8)
                .padding(.top, 4)
                
                Spacer()
                
                StepView(
                    step: swimSet.details[currentIndex],
                    stepNumber: currentIndex + 1,
                    totalSteps: swimSet.details.count
                )
                .padding(.horizontal, 12)
            }
            
            Spacer()
            
            // main navigation
            if !isCompleted
            {
                NavigationControls(
                    currentIndex: $currentIndex,
                    totalSteps: swimSet.details.count
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
        primaryStroke: .freestyle,
        totalDistance: 2000,
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "Progressive endurance set",
        details: [
            "400m warm-up easy mixed strokes",
            "8x100m freestyle on 1:30 - build each 100m",
            "4x200m freestyle on 3:00 - steady pace",
            "8x50m kick with board on 1:00",
            "200m cool down easy backstroke"
        ]
    )
    
    SetDisplayView(swimSet: sampleSet)
}
