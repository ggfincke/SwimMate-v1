// SwimMate/iOSViews/SwimViews/SetView/FilterSheetView/Sections/AdvancedFiltersSection.swift

import SwiftUI

struct AdvancedFiltersSection: View
{
    @Binding var tempFilters: Manager.SetFilters
    
    var body: some View
    {
        Section("Advanced Filters")
        {
            DistanceRangePicker(tempFilters: $tempFilters)
            DurationRangePicker(tempFilters: $tempFilters)
            ComponentTypesSelector(tempFilters: $tempFilters)
        }
    }
}

struct DistanceRangePicker: View
{
    @Binding var tempFilters: Manager.SetFilters
    
    var body: some View
    {
        HStack
        {
            Text("Distance")
            Spacer()
            Picker("", selection: $tempFilters.distanceRange)
            {
                ForEach(Manager.DistanceRange.allCases, id: \.self)
                { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct DurationRangePicker: View
{
    @Binding var tempFilters: Manager.SetFilters
    
    var body: some View
    {
        HStack
        {
            Text("Duration")
            Spacer()
            Picker("", selection: $tempFilters.durationRange)
            {
                ForEach(Manager.DurationRange.allCases, id: \.self)
                { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct ComponentTypesSelector: View
{
    @Binding var tempFilters: Manager.SetFilters
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text("Component Types")
                .font(.headline)

            Text("Select the types of components you want in your sets:")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(spacing: 8)
            {
                ForEach(SetComponent.ComponentType.allCases, id: \.self)
                { type in
                    Button(action:
                        {
                            if tempFilters.componentTypes.contains(type)
                            {
                                tempFilters.componentTypes.remove(type)
                            }
                            else
                            {
                                tempFilters.componentTypes.insert(type)
                            }
                        })
                    {
                        HStack
                        {
                            Image(systemName: tempFilters.componentTypes.contains(type) ? "checkmark.square.fill" : "square")
                                .font(.system(size: 18))
                                .foregroundColor(tempFilters.componentTypes.contains(type) ? .blue : .gray)

                            Text(type.rawValue)
                                .font(.body)
                                .foregroundColor(.primary)

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(tempFilters.componentTypes.contains(type) ? Color.blue.opacity(0.1) : Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

#Preview
{
    @State var sampleFilters = Manager.SetFilters.defaultFilters
    
    return Form
    {
        AdvancedFiltersSection(tempFilters: $sampleFilters)
    }
}