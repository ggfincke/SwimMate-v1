// MetricsView.swift

import SwiftUI

// MetricsView
struct MetricsView: View
{
    @EnvironmentObject var manager: WatchManager
    @State private var isVisible = false
    
    // spacing vars
    private let sectionSpacing: CGFloat = 6
    private let horizontalPadding: CGFloat = 4
    
    var body: some View
    {
        VStack(spacing: sectionSpacing)
        {
            PrimaryMetricsSection()
            SecondaryMetricsGrid()
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 10)
        .padding(.bottom, 4)
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

// preview
#Preview {
    MetricsView()
        .environmentObject(WatchManager())
}
