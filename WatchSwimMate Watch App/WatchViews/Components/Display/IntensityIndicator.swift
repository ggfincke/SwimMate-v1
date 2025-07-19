// IntensityIndicator.swift

import SwiftUI

struct IntensityIndicator: View

{

    let heartRate: Double

    var intensity: Int
    {
        // intensity calc based on heart rate zones
        switch heartRate
        {
            case 0..<100: return 1
            case 100..<130: return 2
            case 130..<150: return 3
            case 150..<170: return 4
            default: return 5
        }
    }

    var body: some View
    {
        HStack(spacing: 2)
        {
            ForEach(1...5, id: \.self)
            {
                level in
                RoundedRectangle(cornerRadius: 2)
                .fill(level <= intensity ? intensityColor : Color.gray.opacity(0.3))
                .frame(width: 3, height: level <= intensity ? 8 : 4)
                .animation(.easeInOut(duration: 0.3), value: intensity)
            }
        }
    }

    private var intensityColor: Color
    {
        switch intensity
        {
            case 1...2: return .green
            case 3: return .yellow
            case 4: return .orange
            default: return .red
        }
    }
}

// preview
#Preview
{
    VStack(spacing: 16)
    {
        HStack
        {
            Text("Low:")
            IntensityIndicator(heartRate: 85)
        }

        HStack
        {
            Text("Medium:")
            IntensityIndicator(heartRate: 140)
        }

        HStack
        {
            Text("High:")
            IntensityIndicator(heartRate: 175)
        }
    }
    .padding()
}
