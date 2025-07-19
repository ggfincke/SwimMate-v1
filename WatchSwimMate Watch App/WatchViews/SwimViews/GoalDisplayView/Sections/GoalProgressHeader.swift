// GoalProgressHeader.swift

import SwiftUI

struct GoalProgressHeader: View

{

    @Environment(WatchManager.self) private var manager

    var body: some View
    {
        HStack
        {
            Image(systemName: "target")
            .font(.system(size: manager.isCompactDevice ? 12 : 16, weight: .semibold))
            .foregroundColor(.blue)
            Text("Goals")
            .font(.system(size: manager.isCompactDevice ? 12 : 16, weight: .semibold))
        }
    }
}

#Preview
{
    GoalProgressHeader()
    .environment(WatchManager())
}