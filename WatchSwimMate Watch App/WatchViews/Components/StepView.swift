// StepView

import SwiftUI

// Step View
struct StepView: View {
    let step: String
    let stepNumber: Int
    let totalSteps: Int
    
    var body: some View
    {
        VStack(spacing: 12)
        {
            
            // step content
            VStack(spacing: 8)
            {
                // from set data
                Text(step)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(minHeight: 60)
                
                // encouragement text
                Text(getEncouragementText())
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .frame(height: 16)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // output encouragement text (depending on set progress)
    private func getEncouragementText() -> String {
        let progress = Double(stepNumber) / Double(totalSteps)
        
        switch progress {
        case 0..<0.3:
            return "Let's get started! 🏊‍♂️"
        case 0.3..<0.6:
            return "Great progress! 💪"
        case 0.6..<0.9:
            return "Almost there! 🌟"
        default:
            return "Final push! 🔥"
        }
    }
}
