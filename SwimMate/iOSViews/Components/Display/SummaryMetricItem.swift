// SwimMate/iOSViews/Components/Display/SummaryMetricItem.swift

import SwiftUI

// individual metric item for summary
struct SummaryMetricItem: View
{
    var emoji: String
    var value: String
    var label: String
    
    var body: some View
    {
        VStack {
            Text(emoji)
                .font(.system(size: 28))
            
            Text(value)
                .font(.headline)
                .padding(.top, 2)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SummaryMetricItem(emoji: "🔥", value: "5", label: "Workouts")
}
