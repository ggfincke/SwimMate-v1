//
//  StatColumn.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI

// MARK: - Supporting Views
struct StatColumn: View
{
    let emoji: String
    let value: String
    let label: String
    
    var body: some View
    {
        VStack(spacing: 8)
        {
            Text(emoji)
                .font(.system(size: 28))
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 2)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
