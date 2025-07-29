// SwimMate/iOSViews/SwimViews/SetView/FilterSheetView/Sections/PreferencesSection.swift

import SwiftUI

struct PreferencesSection: View
{
    @Binding var tempFilters: Manager.SetFilters
    
    var body: some View
    {
        Section("Preferences")
        {
            FavoritesToggle(tempFilters: $tempFilters)
        }
    }
}

struct FavoritesToggle: View
{
    @Binding var tempFilters: Manager.SetFilters
    
    var body: some View
    {
        HStack
        {
            Text("Favorites only")
            Spacer()
            Toggle("", isOn: $tempFilters.showFavorites)
                .labelsHidden()
        }
    }
}

#Preview
{
    @State var sampleFilters = Manager.SetFilters.defaultFilters
    
    return Form
    {
        PreferencesSection(tempFilters: $sampleFilters)
    }
}