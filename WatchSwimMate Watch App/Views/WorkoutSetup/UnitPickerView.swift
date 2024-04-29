//
//  UnitPickerView.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/27/24.
//

import SwiftUI

struct UnitPickerView: View 
{
    @Binding var selectedUnit: String
    @Environment(\.dismiss) var dismiss

    var body: some View 
    {
        VStack 
        {
            Button("Meters")
            {
                selectedUnit = "meters"
                dismiss()
            }


            Button("Yards") 
            {
                selectedUnit = "yards"
                dismiss()
            }

        }
    }
}
//
struct UnitPickerView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedUnit = "meters"

        var body: some View {
            UnitPickerView(selectedUnit: $selectedUnit)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
