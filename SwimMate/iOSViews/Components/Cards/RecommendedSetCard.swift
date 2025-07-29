// SwimMate/iOSViews/Components/Cards/RecommendedSetCard.swift

import SwiftUI

struct RecommendedSetCard: View
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
        VStack(alignment: .leading, spacing: 12)
        {
            // Header
            HStack
            {
                VStack(alignment: .leading, spacing: 4)
                {
                    Text(swimSet.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    Text(swimSet.difficulty.rawValue.capitalized)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(difficultyColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(difficultyColor.opacity(0.15))
                        .cornerRadius(8)
                }

                Spacer()

                Button(action: toggleFavorite)
                {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Stats
            HStack(spacing: 16)
            {
                VStack(alignment: .leading, spacing: 2)
                {
                    Text("Distance")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("\(swimSet.totalDistance)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }

                VStack(alignment: .leading, spacing: 2)
                {
                    Text("Unit")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(swimSet.measureUnit.rawValue)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }

                Spacer()
            }

            // Description
            if let description = swimSet.description, !description.isEmpty
            {
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            // Components preview
            HStack
            {
                Text("\(swimSet.components.count) components")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)

                Spacer()

                if !swimSet.primaryStroke.isEmpty
                {
                    Text(swimSet.strokeDisplayLabel)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
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
    RecommendedSetCard(
        swimSet: SwimSet(
            id: UUID(),
            title: "Sprint Training",
            components: [
                SetComponent(
                    type: .warmup,
                    distance: 400,
                    strokeStyle: .freestyle,
                    instructions: "Easy warm-up"
                ),
            ],
            measureUnit: .meters,
            difficulty: .intermediate,
            description: "High intensity sprint workout for competitive swimmers"
        ),
        isFavorite: false,
        toggleFavorite: {}
    )
    .frame(width: 280)
    .padding()
}
