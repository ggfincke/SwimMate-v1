// SwimMate/iOSViews/SwimViews/SetView/SetDetailView/Sections/SendToWatchSection.swift

import SwiftUI

struct SendToWatchSection: View
{
    let swimSet: SwimSet
    @EnvironmentObject var watchConnector: WatchConnector
    @State private var showingSendSheet = false
    @State private var sendStatus: SendStatus = .ready

    enum SendStatus
    {
        case ready, sending, sent, failed
    }
    
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
        VStack
        {
            Spacer()
            sendToWatchButton
        }
        .sheet(isPresented: $showingSendSheet)
        {
            sendConfirmationSheet
        }
    }

    private var sendToWatchButton: some View
    {
        Button(action:
            {
                showingSendSheet = true
            })
        {
            HStack(spacing: 12)
            {
                Image(systemName: sendStatus == .sending ? "arrow.clockwise" : "paperplane.fill")
                    .font(.system(size: 18, weight: .medium))
                    .rotationEffect(.degrees(sendStatus == .sending ? 360 : 0))
                    .animation(sendStatus == .sending ? .linear(duration: 1).repeatForever(autoreverses: false) : .none, value: sendStatus)

                Text(sendButtonText)
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(sendButtonColor)
            .cornerRadius(25)
            .shadow(color: sendButtonColor.opacity(0.3), radius: 12, x: 0, y: 6)
        }
        .disabled(sendStatus == .sending)
        .scaleEffect(sendStatus == .sending ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: sendStatus)
        .padding(.horizontal)
        .padding(.bottom, 40)
    }

    private var sendButtonText: String
    {
        switch sendStatus
        {
        case .ready: return "Send to Watch"
        case .sending: return "Sending..."
        case .sent: return "Sent!"
        case .failed: return "Retry Send"
        }
    }

    private var sendButtonColor: Color
    {
        switch sendStatus
        {
        case .ready: return .blue
        case .sending: return .blue
        case .sent: return .green
        case .failed: return .red
        }
    }

    private var sendConfirmationSheet: some View
    {
        VStack(spacing: 24)
        {
            // Header
            VStack(spacing: 8)
            {
                Image(systemName: "applewatch")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.blue)

                Text("Send to Apple Watch")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)

                Text("This will send \"\(swimSet.title)\" to your Apple Watch for tracking.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)

            // Set Preview
            VStack(alignment: .leading, spacing: 12)
            {
                Text(swimSet.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)

                HStack
                {
                    Text("Distance:")
                    Spacer()
                    Text("\(swimSet.totalDistance) \(swimSet.measureUnit.rawValue)")
                        .fontWeight(.semibold)
                }

                HStack
                {
                    Text("Components:")
                    Spacer()
                    Text("\(swimSet.components.count)")
                        .fontWeight(.semibold)
                }

                HStack
                {
                    Text("Difficulty:")
                    Spacer()
                    Text(swimSet.difficulty.rawValue.capitalized)
                        .fontWeight(.semibold)
                        .foregroundColor(difficultyColor)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)

            Spacer()

            // Buttons
            VStack(spacing: 12)
            {
                Button(action: sendToWatch)
                {
                    Text("Send Now")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(16)
                }

                Button(action: { showingSendSheet = false })
                {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private func sendToWatch()
    {
        sendStatus = .sending
        showingSendSheet = false

        watchConnector.sendSwimSet(swimSet: swimSet)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
        {
            sendStatus = .sent

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
            {
                sendStatus = .ready
            }
        }
    }
}

#Preview
{
    let sampleSet = SwimSet(
        title: "Endurance Builder",
        components: [
            SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix"),
            SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30")
        ],
        measureUnit: .meters,
        difficulty: .intermediate,
        description: "A challenging set designed to improve endurance."
    )
    
    SendToWatchSection(swimSet: sampleSet)
        .environmentObject(WatchConnector())
}