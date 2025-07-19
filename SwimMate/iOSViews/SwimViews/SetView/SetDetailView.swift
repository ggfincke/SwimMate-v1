// SwimMate/iOSViews/SwimViews/SetView/SetDetailView.swift

import SwiftUI

struct SetDetailView: View
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
        switch swimSet.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
    
    var body: some View
    {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [difficultyColor.opacity(0.15), difficultyColor.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Hero Section
                    heroSection
                    
                    // Stats Cards
                    statsSection
                    
                    // Description Section
                    if let description = swimSet.description, !description.isEmpty {
                        descriptionSection(description)
                    }
                    
                    // Components Section
                    componentsSection
                    
                    Spacer(minLength: 120)
                }
                .padding(.horizontal)
            }
            
            // Floating Send Button
            VStack {
                Spacer()
                sendToWatchButton
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSendSheet) {
            sendConfirmationSheet
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View
    {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
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
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Primary Stroke")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(swimSet.primaryStroke?.description ?? "Mixed")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
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
    
    // MARK: - Stats Section
    private var statsSection: some View
    {
        HStack(spacing: 16) {
            DetailStatCard(
                title: "Distance",
                value: "\(swimSet.totalDistance)",
                unit: swimSet.measureUnit.rawValue,
                icon: "ruler",
                color: .blue
            )
            
            DetailStatCard(
                title: "Duration",
                value: estimatedDurationText,
                unit: "",
                icon: "clock",
                color: .orange
            )
            
            DetailStatCard(
                title: "Difficulty",
                value: swimSet.difficulty.rawValue,
                unit: "",
                icon: "chart.bar.fill",
                color: difficultyColor
            )
        }
    }
    
    private var estimatedDurationText: String
    {
        if let duration = swimSet.estimatedDuration {
            let minutes = Int(duration / 60)
            return "\(minutes) min"
        }
        return "~45 min"
    }
    
    // MARK: - Description Section
    private func descriptionSection(_ description: String) -> some View
    {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(description)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Components Section
    private var componentsSection: some View
    {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout Components")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ForEach(Array(swimSet.components.enumerated()), id: \.element.id) { index, component in
                    ComponentCard(component: component, index: index + 1)
                }
            }
        }
    }
    
    // MARK: - Send to Watch Button
    private var sendToWatchButton: some View
    {
        Button(action: {
            showingSendSheet = true
        }) {
            HStack(spacing: 12) {
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
        switch sendStatus {
        case .ready: return "Send to Watch"
        case .sending: return "Sending..."
        case .sent: return "Sent!"
        case .failed: return "Retry Send"
        }
    }
    
    private var sendButtonColor: Color
    {
        switch sendStatus {
        case .ready: return .blue
        case .sending: return .blue
        case .sent: return .green
        case .failed: return .red
        }
    }
    
    // MARK: - Send Confirmation Sheet
    private var sendConfirmationSheet: some View
    {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
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
            VStack(alignment: .leading, spacing: 12) {
                Text(swimSet.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack {
                    Text("Distance:")
                    Spacer()
                    Text("\(swimSet.totalDistance) \(swimSet.measureUnit.rawValue)")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Components:")
                    Spacer()
                    Text("\(swimSet.components.count)")
                        .fontWeight(.semibold)
                }
                
                HStack {
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
            VStack(spacing: 12) {
                Button(action: sendToWatch) {
                    Text("Send Now")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                
                Button(action: { showingSendSheet = false }) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            sendStatus = .sent
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                sendStatus = .ready
            }
        }
    }
}

// MARK: - Detail Stat Card
struct DetailStatCard: View
{
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View
    {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Component Card
struct ComponentCard: View
{
    let component: SetComponent
    let index: Int
    
    private var componentColor: Color
    {
        switch component.type {
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
        switch component.type {
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
        HStack(spacing: 16) {
            // Step Number
            Text("\(index)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(componentColor)
                .clipShape(Circle())
            
            // Component Details
            VStack(alignment: .leading, spacing: 6) {
                HStack {
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
                
                if let instructions = component.instructions {
                    Text(instructions)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                
                if let strokeStyle = component.strokeStyle {
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

// Preview of the SetDetailView
struct SetDetailView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let sampleSet = SwimSet(
            title: "Sample",
            components: [
                SetComponent(type: .warmup, distance: 800, strokeStyle: .mixed, instructions: "800 warmup mix"),
                SetComponent(type: .swim, distance: 1000, strokeStyle: .freestyle, instructions: "10x100 on 1:30, descend 1-5, 6-10"),
                SetComponent(type: .kick, distance: 500, strokeStyle: .kickboard, instructions: "10x50 kick on 1:00"),
                SetComponent(type: .cooldown, distance: 500, strokeStyle: .mixed, instructions: "500 cool down easy")
            ],
            measureUnit: .meters,
            difficulty: .intermediate,
            description: "A challenging set designed to improve endurance and pace."
        )
        SetDetailView(swimSet: sampleSet)
    }
}


//#Preview
//{
//    let sSet = SwimSet(
//        title: "Quick Set",
//        components: [
//            SetComponent(type: .swim, distance: 200, strokeStyle: .freestyle, instructions: "8x25s Freestyle on 30 seconds"),
//            SetComponent(type: .cooldown, distance: 50, strokeStyle: .mixed, instructions: "2x25s easy")
//        ],
//        measureUnit: .meters,
//        difficulty: .beginner
//    )
//
//    SetDetailView(swimSet: sSet)
//}

