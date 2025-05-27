// HeaderSection.swift

import SwiftUI

// header section for rootview
struct HeaderSection: View
{
    var body: some View
    {
        HStack(spacing: 6)
        {
            Image(systemName: "figure.pool.swim")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.blue)
            
            Text("SwimMate")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

#Preview {
    HeaderSection()
} 
