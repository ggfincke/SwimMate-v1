// ImportSetView.swift

import HealthKit
import SwiftUI

struct ImportSetView: View

{
    @Environment(iOSWatchConnector.self) private var watchConnector
    @Environment(WatchManager.self) private var manager
    @State private var selectedSetId: UUID? = nil
    @State private var isRefreshing = false

    var body: some View
    {
        Group
        {
            if watchConnector.receivedSets.isEmpty
            {
                emptyStateView
            }
            else
            {
                setsListView
            }
        }
        .navigationTitle("Swim Sets")
    }

    // empty state view
    private var emptyStateView: some View
    {
        VStack(spacing: 16)
        {
            Image(systemName: "iphone.and.arrow.forward")
                .font(.system(size: 40))
                .foregroundColor(.blue.opacity(0.7))
                .padding(.top, 20)

            Text("No Sets Found")
                .font(.headline)

            Text("Send sets from the SwimMate app on your iPhone")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: refreshSets)
            {
                HStack
                {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh")
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // set list view
    private var setsListView: some View
    {
        List
        {
            ForEach(watchConnector.receivedSets, id: \.id)
            {
                swimSet in
                setRow(swimSet: swimSet)
                    .listRowBackground(
                        selectedSetId == swimSet.id ?
                            Color.blue.opacity(0.2) :
                            Color.clear
                    )
            }
        }
        .listStyle(.carousel)
        .refreshable
        {
            refreshSets()
        }
    }

    // individual set row
    private func setRow(swimSet: SwimSet) -> some View
    {
        Button(action:
            {
                withAnimation
                {
                    selectedSetId = swimSet.id
                    WKInterfaceDevice.current().play(.click)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3)
                {
                    manager.path.append(NavState.swimmingView(set: swimSet))
                    manager.startWorkout()
                }
            })
        {
            VStack(alignment: .leading, spacing: 6)
            {
                // title w/ stroke type
                HStack
                {
                    Text(swimSet.title)
                        .font(.system(size: 16, weight: .bold))
                        .lineLimit(1)

                    Spacer()

                    // difficulty badge
                    Text(swimSet.difficulty.rawValue)
                        .font(.system(size: 10, weight: .medium))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(difficultyColor(for: swimSet.difficulty))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }

                // distance & stroke
                HStack
                {
                    Image(systemName: "figure.pool")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)

                    Text("\(swimSet.totalDistance) \(swimSet.measureUnit.rawValue)")
                        .font(.system(size: 14))

                    Spacer()

                    Text(swimSet.primaryStroke?.description ?? "Mixed")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }

                // desc preview
                if let description = swimSet.description, !description.isEmpty
                {
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .padding(.top, 2)
                }

                // start button (for quick access)
                Button(action:
                    {
                        WKInterfaceDevice.current().play(.success)
                        manager.path.append(NavState.swimmingView(set: swimSet))
                        manager.startWorkout()
                    })
                {
                    HStack
                    {
                        Text("Start")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 4)
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // refresh
    private func refreshSets()
    {
        withAnimation
        {
            isRefreshing = true
        }

        // simulate refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            withAnimation
            {
                isRefreshing = false
            }
        }
    }

    // color based on difficulty
    private func difficultyColor(for difficulty: SwimSet.Difficulty) -> Color
    {
        switch difficulty
        {
        case .beginner:
            return .green
        case .intermediate:
            return .blue
        case .advanced:
            return .red
        }
    }
}

#Preview
{
    ImportSetView()
        .environment(iOSWatchConnector())
        .environment(WatchManager())
}
