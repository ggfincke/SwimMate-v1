// NavigationControls.swift

import SwiftUI

// nav controls (uses nav buttons)
struct NavigationControls: View

{
    // helper funcs
    @Binding var currentIndex: Int
    let totalSteps: Int

    private var canGoBack: Bool
    {
        currentIndex > 0
    }

    private var canGoForward: Bool
    {
        currentIndex < totalSteps - 1
    }

    private var isLastStep: Bool
    {
        currentIndex == totalSteps - 1
    }

    var body: some View
    {
        HStack(spacing: 12)
        {
            // prev button
            CompactNavButton(
                icon: "chevron.left",
                isEnabled: canGoBack,
                color: .gray
            )
            {
                if canGoBack
                {
                    withAnimation(.easeInOut(duration: 0.2))
                    {
                        currentIndex -= 1
                    }
                    WKInterfaceDevice.current().play(.click)
                }
            }

            Spacer()

            // step indicator
            Text("\(currentIndex + 1) of \(totalSteps)")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                )

            Spacer()

            // next/complete button
            CompactNavButton(
                icon: isLastStep ? "checkmark" : "chevron.right",
                isEnabled: true,
                color: isLastStep ? .green : .blue
            )
            {
                // if last step, next push ends set
                if isLastStep
                {
                    // complete set
                    withAnimation(.easeInOut(duration: 0.2))
                    {
                        currentIndex = totalSteps
                    }
                    WKInterfaceDevice.current().play(.success)
                }
                else
                {
                    // next step
                    withAnimation(.easeInOut(duration: 0.2))
                    {
                        currentIndex += 1
                    }
                    WKInterfaceDevice.current().play(.click)
                }
            }
        }
    }
}

// preview
#Preview
{
    VStack(spacing: 20)
    {
        // start of workout
        NavigationControls(
            currentIndex: .constant(0),
            totalSteps: 5
        )

        // middle of workout
        NavigationControls(
            currentIndex: .constant(2),
            totalSteps: 5
        )

        // last step
        NavigationControls(
            currentIndex: .constant(4),
            totalSteps: 5
        )
    }
    .padding()
}
