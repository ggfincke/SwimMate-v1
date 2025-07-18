// SwimMate/iOSViews/SwimViews/SetView/FilterSheetView.swift

import SwiftUI

struct FilterSheetView: View {
    @EnvironmentObject var manager: Manager
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempFilters: Manager.SetFilters
    
    init() {
        _tempFilters = State(initialValue: Manager.SetFilters.defaultFilters)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Filters Section
                Section("Basic Filters") {
                    strokePicker
                    difficultyPicker
                    unitPicker
                }
                
                // Advanced Filters Section
                Section("Advanced Filters") {
                    distanceRangePicker
                    durationRangePicker
                    componentTypesSelector
                }
                
                // Workout Structure Section
                Section("Workout Structure") {
                    warmupCooldownToggles
                    favoritesToggle
                }
                
                // Quick Filters Section
                Section("Quick Filters") {
                    quickFilterButtons
                }
            }
            .navigationTitle("Filter Sets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        manager.activeFilters = tempFilters
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                tempFilters = manager.activeFilters
            }
        }
    }
    
    // MARK: - Stroke Picker
    private var strokePicker: some View {
        HStack {
            Text("Stroke")
            Spacer()
            Picker("Stroke", selection: Binding(
                get: { tempFilters.stroke ?? SwimStroke.freestyle },
                set: { tempFilters.stroke = $0 == SwimStroke.freestyle ? nil : $0 }
            )) {
                Text("Any").tag(SwimStroke.freestyle)
                ForEach([SwimStroke.freestyle, .backstroke, .breaststroke, .butterfly, .mixed], id: \.self) { stroke in
                    Text(stroke.description).tag(stroke)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    // MARK: - Difficulty Picker
    private var difficultyPicker: some View {
        HStack {
            Text("Difficulty")
            Spacer()
            Picker("Difficulty", selection: Binding(
                get: { tempFilters.difficulty ?? .beginner },
                set: { tempFilters.difficulty = $0 == .beginner ? nil : $0 }
            )) {
                Text("Any").tag(SwimSet.Difficulty.beginner)
                ForEach(SwimSet.Difficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.rawValue).tag(difficulty)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    // MARK: - Unit Picker
    private var unitPicker: some View {
        HStack {
            Text("Unit")
            Spacer()
            Picker("Unit", selection: Binding(
                get: { tempFilters.unit ?? .meters },
                set: { tempFilters.unit = $0 == .meters ? nil : $0 }
            )) {
                Text("Any").tag(MeasureUnit.meters)
                ForEach(MeasureUnit.allCases, id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    // MARK: - Distance Range Picker
    private var distanceRangePicker: some View {
        HStack {
            Text("Distance")
            Spacer()
            Picker("Distance Range", selection: $tempFilters.distanceRange) {
                ForEach(Manager.DistanceRange.allCases, id: \.self) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    // MARK: - Duration Range Picker
    private var durationRangePicker: some View {
        HStack {
            Text("Duration")
            Spacer()
            Picker("Duration Range", selection: $tempFilters.durationRange) {
                ForEach(Manager.DurationRange.allCases, id: \.self) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    // MARK: - Component Types Selector
    private var componentTypesSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Component Types")
                .font(.headline)
            
            Text("Select the types of components you want in your sets:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(SetComponent.ComponentType.allCases, id: \.self) { type in
                    Button(action: {
                        if tempFilters.componentTypes.contains(type) {
                            tempFilters.componentTypes.remove(type)
                        } else {
                            tempFilters.componentTypes.insert(type)
                        }
                    }) {
                        HStack {
                            Image(systemName: tempFilters.componentTypes.contains(type) ? "checkmark.square.fill" : "square")
                                .foregroundColor(tempFilters.componentTypes.contains(type) ? .blue : .gray)
                            
                            Text(type.rawValue)
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tempFilters.componentTypes.contains(type) ? Color.blue.opacity(0.1) : Color(UIColor.systemGray6))
                        .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Warmup/Cooldown Toggles
    private var warmupCooldownToggles: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Must have warmup")
                Spacer()
                Button(action: {
                    tempFilters.hasWarmup = tempFilters.hasWarmup == true ? nil : true
                }) {
                    Image(systemName: tempFilters.hasWarmup == true ? "checkmark.square.fill" : "square")
                        .foregroundColor(tempFilters.hasWarmup == true ? .blue : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            HStack {
                Text("Must have cooldown")
                Spacer()
                Button(action: {
                    tempFilters.hasCooldown = tempFilters.hasCooldown == true ? nil : true
                }) {
                    Image(systemName: tempFilters.hasCooldown == true ? "checkmark.square.fill" : "square")
                        .foregroundColor(tempFilters.hasCooldown == true ? .blue : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Favorites Toggle
    private var favoritesToggle: some View {
        HStack {
            Text("Favorites only")
            Spacer()
            Toggle("", isOn: $tempFilters.showFavorites)
                .labelsHidden()
        }
    }
    
    // MARK: - Quick Filter Buttons
    private var quickFilterButtons: some View {
        VStack(spacing: 12) {
            Text("Quick Presets")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                quickFilterButton(
                    title: "Beginner Friendly",
                    description: "Easy sets with warmup/cooldown",
                    action: {
                        tempFilters.difficulty = .beginner
                        tempFilters.hasWarmup = true
                        tempFilters.hasCooldown = true
                        tempFilters.distanceRange = .short
                    }
                )
                
                quickFilterButton(
                    title: "Sprint Training",
                    description: "High intensity, short distance",
                    action: {
                        tempFilters.difficulty = .advanced
                        tempFilters.distanceRange = .short
                        tempFilters.durationRange = .quick
                    }
                )
                
                quickFilterButton(
                    title: "Endurance Builder",
                    description: "Long distance, moderate pace",
                    action: {
                        tempFilters.distanceRange = .long
                        tempFilters.durationRange = .long
                        tempFilters.difficulty = .intermediate
                    }
                )
                
                quickFilterButton(
                    title: "Technique Focus",
                    description: "Sets with drills and technique work",
                    action: {
                        tempFilters.componentTypes.insert(.drill)
                        tempFilters.difficulty = .intermediate
                        tempFilters.distanceRange = .medium
                    }
                )
            }
            
            // Reset button
            Button(action: {
                tempFilters = Manager.SetFilters.defaultFilters
            }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset All Filters")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Quick Filter Button Helper
    private func quickFilterButton(title: String, description: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Search Sheet View
struct SearchSheetView: View {
    @EnvironmentObject var manager: Manager
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search sets...", text: $searchText)
                        .focused($isSearchFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            performSearch()
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
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
                if searchText.isEmpty {
                    VStack {
                        Text("Search Tips")
                            .font(.headline)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 8) {
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
                } else {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        performSearch()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                searchText = manager.activeFilters.searchText
                isSearchFocused = true
            }
        }
    }
    
    private func performSearch() {
        manager.updateFilter(\.searchText, to: searchText)
    }
}

#Preview {
    FilterSheetView()
        .environmentObject(Manager())
}
