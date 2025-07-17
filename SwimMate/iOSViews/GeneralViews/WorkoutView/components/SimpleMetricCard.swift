//
//  SimpleMetricCard.swift
//  SwimMate
//
//  Created by Garrett Fincke on 7/16/25.
//

import SwiftUI

struct SimpleMetricCard: View
{
    let emoji: String
    let value: String
    let label: String
    let subtitle: String
    
    var body: some View
    {
        VStack(spacing: 8)
        {
            Text(emoji)
                .font(.system(size: 28))
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 2)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}
