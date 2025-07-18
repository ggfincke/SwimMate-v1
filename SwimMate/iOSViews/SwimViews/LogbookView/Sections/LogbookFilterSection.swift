// SwimMate/iOSViews/SwimViews/LogbookView/Sections/LogbookFilterSection.swift

import SwiftUI

struct LogbookFilterSection: View {
    @Binding var selectedFilter: LogbookView.TimeFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(LogbookView.TimeFilter.allCases) { filter in
                    TimeFilterChip(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        action: { selectedFilter = filter }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    LogbookFilterSection(selectedFilter: .constant(.thirtyDays))
}