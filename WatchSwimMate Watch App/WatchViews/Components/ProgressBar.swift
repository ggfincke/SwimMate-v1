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
