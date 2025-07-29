// SwimMate/iOSViews/SwimViews/SetView/SetDetailView/Sections/HeroSection.swift

import SwiftUI

struct HeroSection: View
{
    let swimSet: SwimSet
    @EnvironmentObject var manager: Manager

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
        VStack(alignment: .leading, spacing: 16)
        {
            HStack
            {
                VStack(alignment: .leading, spacing: 8)
                {
                    Text(swimSet.difficulty.rawValue.capitalized)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(difficultyColor)
                        .cornerRadius(12)

                    Text(swimSet.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }

                Spacer()

                // Favorite Button
                Button(action: { manager.toggleFavorite(setId: swimSet.id) })
                {
                    Image(systemName: manager.isSetFavorite(setId: swimSet.id) ? "heart.fill" : "heart")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(manager.isSetFavorite(setId: swimSet.id) ? .red : .gray)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(manager.isSetFavorite(setId: swimSet.id) ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: manager.isSetFavorite(setId: swimSet.id))
            }

            HStack(spacing: 16)
            {
                VStack(alignment: .leading, spacing: 4)
                {
                    Text("Primary Stroke")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(swimSet.strokeDisplayLabelDetailed)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4)
                {
                    Text("Components")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("\(swimSet.components.count)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 8)
    }
}

#Preview
{
    let sampleSet = SwimSet(
        title: "Endurance Builder",
        components: [
            SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30"),
        ],
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "A challenging set designed to improve endurance."
    )

    HeroSection(swimSet: sampleSet)
        .padding()
        .environmentObject(Manager())
}
