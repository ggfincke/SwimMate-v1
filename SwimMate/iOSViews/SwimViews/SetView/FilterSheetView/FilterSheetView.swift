// SwimMate/iOSViews/SwimViews/SetView/FilterSheetView/FilterSheetView.swift

import SwiftUI

struct FilterSheetView: View
{
    @EnvironmentObject var manager: Manager
    @Environment(\.dismiss) private var dismiss

    @State private var tempFilters: Manager.SetFilters

    init()
    {
        _tempFilters = State(initialValue: Manager.SetFilters.defaultFilters)
    }

    var body: some View
    {
        NavigationView
        {
            Form
            {
                BasicFiltersSection(tempFilters: $tempFilters)
                AdvancedFiltersSection(tempFilters: $tempFilters)
                PreferencesSection(tempFilters: $tempFilters)
            }
            .navigationTitle("Filter Sets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItem(placement: .navigationBarLeading)
                {
                    Button("Cancel")
                    {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .principal)
                {
                    Button("Reset")
                    {
                        tempFilters = Manager.SetFilters.defaultFilters
                    }
                    .foregroundColor(.red)
                }

                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button("Apply")
                    {
                        manager.activeFilters = tempFilters
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear
            {
                tempFilters = manager.activeFilters
            }
        }
    }
}

#Preview
{
    FilterSheetView()
        .environmentObject(Manager())
}
