//
//  SimpleLapRow.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI

struct SimpleLapRow: View
{
    let lapNumber: Int
    let lap: Lap
    
    var body: some View
    {
        HStack
        {
            // Lap number
            Text("\(lapNumber)")
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 40, alignment: .leading)
            
            // Stroke type
            Text(lap.strokeStyle?.description ?? "Unknown")
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Time
            Text(String(format: "%.1fs", lap.duration))
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 60, alignment: .trailing)
            
            // SWOLF
            Text(lap.swolfScore != nil ? String(format: "%.1f", lap.swolfScore!) : "—")
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(lap.swolfScore != nil ? .white : .secondary)
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(lapNumber % 2 == 0 ? Color.clear : Color.secondary.opacity(0.05))
    }
}
