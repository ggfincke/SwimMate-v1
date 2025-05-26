// ProgressBar.swift

import SwiftUI

// progress bar
struct ProgressBar: View
{
    let current: Int
    let total: Int
    
    private var progress: Double
    {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }
    
    var body: some View
    {
        GeometryReader
        { geometry in
            ZStack(alignment: .leading)
            {
                // background
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 3)
                
                // progress
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(
                        width: geometry.size.width * progress,
                        height: 3
                    )
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 3)
    }
}

// preview
#Preview
{
    VStack(spacing: 16)
    {
        VStack(alignment: .leading, spacing: 4)
        {
            Text("25% Complete")
                .font(.caption)
            ProgressBar(current: 25, total: 100)
        }
        
        VStack(alignment: .leading, spacing: 4)
        {
            Text("60% Complete")
                .font(.caption)
            ProgressBar(current: 6, total: 10)
        }
        
        VStack(alignment: .leading, spacing: 4)
        {
            Text("90% Complete")
                .font(.caption)
            ProgressBar(current: 9, total: 10)
        }
    }
    .padding()
}
