// SwimMate/iOSViews/SwimViews/LogbookView/Sections/LogbookHeaderSection.swift

import SwiftUI

struct LogbookHeaderSection: View
{
    @EnvironmentObject var manager: Manager
    @Binding var searchText: String
    let filteredWorkoutsCount: Int
    
    var body: some View
    {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Swim Logbook")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("\(filteredWorkoutsCount) swim\(filteredWorkoutsCount != 1 ? "s" : "") recorded")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search workouts...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

#Preview {
    LogbookHeaderSection(searchText: .constant(""), filteredWorkoutsCount: 5)
        .environmentObject(Manager())
}