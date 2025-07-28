// SwimMate/iOSViews/SwimViews/SetView/FilterSheetView.swift

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
                // Basic Filters Section
                Section("Basic Filters")
                {
                    strokePicker
                    difficultyPicker
                    unitPicker
                }

                // Advanced Filters Section
                Section("Advanced Filters")
                {
                    distanceRangePicker
                    durationRangePicker
                    componentTypesSelector
                }

                // Preferences Section
                Section("Preferences")
                {
                    favoritesToggle
                }
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

    // MARK: - Stroke Picker

    private var strokePicker: some View
    {
        HStack
        {
            Text("Stroke")
            Spacer()
            Picker("", selection: Binding(
                get: { tempFilters.stroke ?? SwimStroke.freestyle },
                set: { tempFilters.stroke = $0 == SwimStroke.freestyle ? nil : $0 }
            ))
            {
                Text("Any").tag(SwimStroke.freestyle)
                ForEach([SwimStroke.freestyle, .backstroke, .breaststroke, .butterfly, .mixed], id: \.self)
                { stroke in
                    Text(stroke.description).tag(stroke)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }

    // MARK: - Difficulty Picker

    private var difficultyPicker: some View
    {
        HStack
        {
            Text("Difficulty")
            Spacer()
            Picker("", selection: Binding(
                get: { tempFilters.difficulty ?? .beginner },
                set: { tempFilters.difficulty = $0 == .beginner ? nil : $0 }
            ))
            {
                Text("Any").tag(SwimSet.Difficulty.beginner)
                ForEach(SwimSet.Difficulty.allCases, id: \.self)
                { difficulty in
                    Text(difficulty.rawValue).tag(difficulty)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }

    // MARK: - Unit Picker

    private var unitPicker: some View
    {
        HStack
        {
            Text("Unit")
            Spacer()
            Picker("", selection: Binding(
                get: { tempFilters.unit ?? .meters },
                set: { tempFilters.unit = $0 == .meters ? nil : $0 }
            ))
            {
                Text("Any").tag(MeasureUnit.meters)
                ForEach(MeasureUnit.allCases, id: \.self)
                { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }

    // MARK: - Distance Range Picker

    private var distanceRangePicker: some View
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

    // MARK: - Duration Range Picker

    private var durationRangePicker: some View
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

    // MARK: - Component Types Selector

    private var componentTypesSelector: some View
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

    // MARK: - Favorites Toggle

    private var favoritesToggle: some View
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

// MARK: - Search Sheet View

struct SearchSheetView: View
{
    @EnvironmentObject var manager: Manager
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    var body: some View
    {
        NavigationView
        {
            VStack
            {
                // Search Bar
                HStack
                {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)

                    TextField("Search sets...", text: $searchText)
                        .focused($isSearchFocused)
                        .submitLabel(.search)
                        .onSubmit
                        {
                            performSearch()
                        }

                    if !searchText.isEmpty
                    {
                        Button(action:
                            {
                                searchText = ""
                            })
                        {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding()

                // Recent searches or suggestions could go here
                if searchText.isEmpty
                {
                    VStack
                    {
                        Text("Search Tips")
                            .font(.headline)
                            .padding(.top)

                        VStack(alignment: .leading, spacing: 8)
                        {
                            Text("• Search by set name")
                            Text("• Search by stroke type")
                            Text("• Search by description")
                            Text("• Try terms like 'sprint', 'endurance', 'technique'")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                    }

                    Spacer()
                }
                else
                {
                    // Live search results could be shown here
                    Text("Press 'Apply' to search")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()

                    Spacer()
                }
            }
            .navigationTitle("Search Sets")
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

                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button("Apply")
                    {
                        performSearch()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear
            {
                searchText = manager.activeFilters.searchText
                isSearchFocused = true
            }
        }
    }

    private func performSearch()
    {
        manager.updateFilter(\.searchText, to: searchText)
    }
}

#Preview
{
    FilterSheetView()
        .environmentObject(Manager())
}
