// SwimMate/iOSViews/SwimViews/SetView/FilterSheetView/Sections/BasicFiltersSection.swift

import SwiftUI

struct BasicFiltersSection: View
{
    @Binding var tempFilters: Manager.SetFilters

    var body: some View
    {
        Section("Basic Filters")
        {
            StrokePicker(tempFilters: $tempFilters)
            DifficultyPicker(tempFilters: $tempFilters)
            UnitPicker(tempFilters: $tempFilters)
        }
    }
}

struct StrokePicker: View
{
    @Binding var tempFilters: Manager.SetFilters

    var body: some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            HStack
            {
                Text("Strokes")
                    .font(.headline)
                Spacer()
                Toggle("IM", isOn: $tempFilters.isIMFilter)
                    .onChange(of: tempFilters.isIMFilter)
                    { _, newValue in
                        if newValue
                        {
                            tempFilters.strokes.removeAll()
                        }
                    }
            }

            Text("Select individual strokes or use IM filter:")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(spacing: 8)
            {
                ForEach([SwimStroke.freestyle, .backstroke, .breaststroke, .butterfly], id: \.self)
                { stroke in
                    Button(action:
                        {
                            if tempFilters.strokes.contains(stroke)
                            {
                                tempFilters.strokes.remove(stroke)
                            }
                            else
                            {
                                tempFilters.strokes.insert(stroke)
                                tempFilters.isIMFilter = false
                            }

                            // Auto-select IM if all 4 strokes are selected
                            let allStrokes: Set<SwimStroke> = [.freestyle, .backstroke, .breaststroke, .butterfly]
                            if tempFilters.strokes == allStrokes
                            {
                                tempFilters.strokes.removeAll()
                                tempFilters.isIMFilter = true
                            }
                        })
                    {
                        HStack
                        {
                            Image(systemName: tempFilters.strokes.contains(stroke) ? "checkmark.square.fill" : "square")
                                .font(.system(size: 18))
                                .foregroundColor(tempFilters.strokes.contains(stroke) ? .blue : .gray)

                            Text(stroke.description)
                                .font(.body)
                                .foregroundColor(.primary)

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(tempFilters.strokes.contains(stroke) ? Color.blue.opacity(0.1) : Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(tempFilters.isIMFilter)
                }
            }
        }
    }
}

struct DifficultyPicker: View
{
    @Binding var tempFilters: Manager.SetFilters

    private var difficultySelection: Binding<SwimSet.Difficulty?>
    {
        Binding<SwimSet.Difficulty?>(
            get: { tempFilters.difficulty },
            set: { tempFilters.difficulty = $0 }
        )
    }

    var body: some View
    {
        HStack
        {
            Text("Difficulty")
            Spacer()
            Picker("", selection: difficultySelection)
            {
                Text("Any").tag(nil as SwimSet.Difficulty?)
                ForEach(SwimSet.Difficulty.allCases, id: \.self)
                { difficulty in
                    Text(difficulty.rawValue).tag(difficulty as SwimSet.Difficulty?)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct UnitPicker: View
{
    @Binding var tempFilters: Manager.SetFilters

    private var unitSelection: Binding<MeasureUnit?>
    {
        Binding<MeasureUnit?>(
            get: { tempFilters.unit },
            set: { tempFilters.unit = $0 }
        )
    }

    var body: some View
    {
        HStack
        {
            Text("Unit")
            Spacer()
            Picker("", selection: unitSelection)
            {
                Text("Any").tag(nil as MeasureUnit?)
                ForEach(MeasureUnit.allCases, id: \.self)
                { unit in
                    Text(unit.rawValue).tag(unit as MeasureUnit?)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

#Preview
{
    @Previewable @State var sampleFilters = Manager.SetFilters.defaultFilters
    Form
    {
        BasicFiltersSection(tempFilters: $sampleFilters)
    }
}
