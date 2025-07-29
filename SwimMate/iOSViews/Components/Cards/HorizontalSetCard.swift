// SwimMate/iOSViews/Components/Cards/HorizontalSetCard.swift

import SwiftUI

struct HorizontalSetCard: View
{
    let swimSet: SwimSet
    let isFavorite: Bool
    let toggleFavorite: () -> Void

    private var difficultyColor: Color
    {
        switch swimSet.difficulty
        {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }

    var body: some View
    {
        HStack(spacing: 16)
        {
            // Left Section: Title, Difficulty, Description
            VStack(alignment: .leading, spacing: 8)
            {
                // Title and Difficulty Badge
                VStack(alignment: .leading, spacing: 6)
                {
                    Text(swimSet.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(swimSet.difficulty.rawValue.capitalized)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(difficultyColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(difficultyColor.opacity(0.15))
                        .cornerRadius(8)
                }

                // Description
                if let description = swimSet.description, !description.isEmpty
                {
                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Right Section: Metrics and Actions
            VStack(alignment: .trailing, spacing: 8)
            {
                // Favorite Button
                Button(action: toggleFavorite)
                {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()

                // Metrics
                VStack(alignment: .trailing, spacing: 6)
                {
                    // Distance
                    VStack(alignment: .trailing, spacing: 2)
                    {
                        Text("Distance")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("\(swimSet.totalDistance)\(swimSet.measureUnit.abbreviation)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                    }

                    // Components
                    VStack(alignment: .trailing, spacing: 2)
                    {
                        Text("Components")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("\(swimSet.components.count)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }

                    // Primary Stroke
                    if !swimSet.primaryStroke.isEmpty
                    {
                        VStack(alignment: .trailing, spacing: 2)
                        {
                            Text("Stroke")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                            HStack(spacing: 4)
                            {
                                Image(systemName: "figure.pool.swim")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                                Text(swimSet.strokeDisplayLabelDetailed)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .frame(width: 100)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(difficultyColor.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview
{
    let sampleSet1 = SwimSet(
        title: "Sprint Interval Training Set",
        components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .freestyle),
            SetComponent(type: .swim, distance: 400, strokeStyle: .freestyle),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .freestyle),
        ],
        difficulty: .intermediate,
        description: "High-intensity sprint intervals to build speed and power in the pool",
        primaryStroke: [.freestyle]
    )

    let sampleSet2 = SwimSet(
        title: "Endurance Challenge",
        components: [
            SetComponent(type: .warmup, distance: 300, strokeStyle: .freestyle),
            SetComponent(type: .swim, distance: 800, strokeStyle: .freestyle),
            SetComponent(type: .swim, distance: 400, strokeStyle: .backstroke),
            SetComponent(type: .cooldown, distance: 200, strokeStyle: .freestyle),
        ],
        difficulty: .advanced,
        description: "Long distance set designed to build aerobic capacity and endurance",
        primaryStroke: [.freestyle, .backstroke]
    )

    VStack(spacing: 16)
    {
        HorizontalSetCard(
            swimSet: sampleSet1,
            isFavorite: false,
            toggleFavorite: {}
        )

        HorizontalSetCard(
            swimSet: sampleSet2,
            isFavorite: true,
            toggleFavorite: {}
        )
    }
    .padding()
}
