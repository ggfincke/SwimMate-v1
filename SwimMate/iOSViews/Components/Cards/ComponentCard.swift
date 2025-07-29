// SwimMate/iOSViews/Components/Cards/ComponentCard.swift

import SwiftUI

struct ComponentCard: View
{
    let component: SetComponent
    let index: Int

    private var componentColor: Color
    {
        switch component.type
        {
        case .warmup: return .orange
        case .swim: return .blue
        case .drill: return .purple
        case .kick: return .green
        case .pull: return .red
        case .cooldown: return .teal
        }
    }

    private var componentIcon: String
    {
        switch component.type
        {
        case .warmup: return "thermometer.sun"
        case .swim: return "figure.pool.swim"
        case .drill: return "gear"
        case .kick: return "figure.strengthtraining.functional"
        case .pull: return "hand.raised"
        case .cooldown: return "snowflake"
        }
    }

    var body: some View
    {
        HStack(spacing: 16)
        {
            // Step Number
            Text("\(index)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(componentColor)
                .clipShape(Circle())

            // Component Details
            VStack(alignment: .leading, spacing: 6)
            {
                HStack
                {
                    Image(systemName: componentIcon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(componentColor)

                    Text(component.type.rawValue.capitalized)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(componentColor)

                    Spacer()

                    Text("\(component.distance)m")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                }

                if let instructions = component.instructions
                {
                    Text(instructions)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }

                if let strokeStyle = component.strokeStyle
                {
                    Text(strokeStyle.description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(componentColor.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview
{
    VStack(spacing: 12)
    {
        ComponentCard(
            component: SetComponent(
                type: .warmup,
                distance: 800,
                strokeStyle: .mixed,
                instructions: "800 warmup mix - easy pace"
            ),
            index: 1
        )

        ComponentCard(
            component: SetComponent(
                type: .swim,
                distance: 1000,
                strokeStyle: .freestyle,
                instructions: "10x100 on 1:30, descend 1-5, 6-10"
            ),
            index: 2
        )

        ComponentCard(
            component: SetComponent(
                type: .cooldown,
                distance: 500,
                strokeStyle: .mixed,
                instructions: "500 cool down easy"
            ),
            index: 3
        )
    }
    .padding()
}
