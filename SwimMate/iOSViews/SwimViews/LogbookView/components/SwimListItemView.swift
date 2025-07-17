// SwimMate/iOSViews/LogbookView/components/SwimListItemView.swift

import SwiftUI

// swim list item
struct SwimListItemView: View {
    let swim: Swim
    @EnvironmentObject var manager: Manager
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dateFormatter.string(from: swim.date))
                .font(.headline)
            
            HStack {
                if let distance = swim.totalDistance, distance > 0 {
                    HStack(spacing: 4) {
                        Text("🌊")
                        Text(manager.formatDistance(distance))
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("⏱️")
                    Text(formatDuration(swim.duration))
                }
            }
            .font(.subheadline)
            
            if let strokes = getStrokes(from: swim) {
                Text(strokes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    // XX min
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    // extract stroke types from swim laps
    private func getStrokes(from swim: Swim) -> String? {
        let uniqueStrokes = Set(swim.laps.compactMap { $0.strokeStyle?.description })
        if uniqueStrokes.isEmpty {
            return nil
        }
        return uniqueStrokes.joined(separator: ", ")
    }
}
