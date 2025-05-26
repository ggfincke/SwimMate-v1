// InsightRow.swift

import SwiftUI

// insight row
struct InsightRow: View
{
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View
    {
        HStack
        {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 16)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}
