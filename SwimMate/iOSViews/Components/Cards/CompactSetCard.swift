// SwimMate/iOSViews/Components/Cards/CompactSetCard.swift

import SwiftUI

struct CompactSetCard: View
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
        VStack(alignment: .leading, spacing: 8)
        {
            // Title Section - Fixed Height
            VStack(alignment: .leading, spacing: 0)
            {
                Text(swimSet.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 40, alignment: .top) // Fixed height for 2 lines

            // Difficulty Badge + Distance
            HStack(spacing: 8)
            {
                Text(swimSet.difficulty.rawValue)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(difficultyColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(difficultyColor.opacity(0.15))
                    .cornerRadius(6)

                Spacer()

                Text("\(swimSet.totalDistance)\(swimSet.measureUnit.abbreviation)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
            }

            // Bottom Row: Favorite + Components + Stroke
            HStack(spacing: 4)
            {
                // Favorite icon (display only, no action)
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isFavorite ? .red : .gray)

                Image(systemName: "list.bullet")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)

                Text("\(swimSet.components.count)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)

                Spacer()

                if let primaryStroke = swimSet.primaryStroke
                {
                    HStack(spacing: 2)
                    {
                        Image(systemName: "figure.pool.swim")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)

                        Text(primaryStroke.abbreviation)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 110) // Fixed card height
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(difficultyColor.opacity(0.2), lineWidth: 1)
        )
    }
}

// Extension to add abbreviation property to SwimStroke
private extension SwimStroke
{
    var abbreviation: String
    {
        switch self
        {
        case .freestyle: return "Free"
        case .backstroke: return "Back"
        case .breaststroke: return "Breast"
        case .butterfly: return "Fly"
        case .mixed: return "Mixed"
        default: return "Other"
        }
    }
}

#Preview
{
    let sampleSet = SwimSet(
        title: "Sprint Interval Training Set",
        components: [
            SetComponent(type: .warmup, distance: 200, strokeStyle: .freestyle),
            SetComponent(type: .swim, distance: 400, strokeStyle: .freestyle),
            SetComponent(type: .cooldown, distance: 100, strokeStyle: .freestyle),
        ],
        difficulty: .intermediate,
        description: "High-intensity sprint intervals to build speed and power"
    )

    HStack(spacing: 16)
    {
        CompactSetCard(
            swimSet: sampleSet,
            isFavorite: false,
            toggleFavorite: {}
        )

        CompactSetCard(
            swimSet: sampleSet,
            isFavorite: true,
            toggleFavorite: {}
        )
    }
    .padding()
}
