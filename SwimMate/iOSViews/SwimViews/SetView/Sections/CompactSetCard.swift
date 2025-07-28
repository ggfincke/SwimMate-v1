// CompactSetCard.swift
// SwimMate/iOSViews/SwimViews/SetView/Sections/

import SwiftUI

struct CompactSetCard: View {
    let swimSet: SwimSet
    let isFavorite: Bool
    let toggleFavorite: () -> Void

    private var difficultyColor: Color {
        switch swimSet.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(swimSet.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Spacer()
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }

            Text(swimSet.difficulty.rawValue.capitalized)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(difficultyColor)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(difficultyColor.opacity(0.12))
                .cornerRadius(6)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Dist")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("\(swimSet.totalDistance)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text("Unit")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(swimSet.measureUnit.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                }
                Spacer()
                if let primaryStroke = swimSet.primaryStroke {
                    Image(systemName: "figure.pool.swim")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(10)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(difficultyColor.opacity(0.16), lineWidth: 1)
        )
    }
}

// Preview for CompactSetCard
#Preview {
    let set = SwimSet(
        title: "Sprint 10x50 Free",
        components: [SetComponent(type: .swim, distance: 500, strokeStyle: .freestyle, instructions: "10x50 sprint")],
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "Sprint set"
    )
    return CompactSetCard(swimSet: set, isFavorite: false, toggleFavorite: {})
}
